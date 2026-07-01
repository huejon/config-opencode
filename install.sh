#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="git@github.com:huejon/config-opencode.git"
DEFAULT_BRANCH="main"

repo_url="$DEFAULT_REPO_URL"
branch="$DEFAULT_BRANCH"
dry_run=0
force=0
color_mode="auto"
target_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
c_reset=''
c_bold=''
c_blue=''
c_green=''
c_yellow=''
c_red=''

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Install this shared OpenCode config repo into ~/.config/opencode.

Options:
  --dry-run            Show planned actions without changing files.
  --force              Allow install/update when an existing target repo has
                       uncommitted tracked changes.
  --repo-url <url>     Git repository URL to clone or update from.
  --branch <name>      Branch to clone or fast-forward update (default: main).
  --no-color           Disable colored output.
  -h, --help           Show this help.

The installer backs up an existing ~/.config/opencode by moving it to a
timestamped sibling directory before cloning, unless it is already this repo.
USAGE
}

is_tty() { [ -t 1 ]; }

setup_color() {
  if [ "$color_mode" = "always" ] || { [ "$color_mode" = "auto" ] && is_tty; }; then
    c_reset='\033[0m'
    c_bold='\033[1m'
    c_blue='\033[34m'
    c_green='\033[32m'
    c_yellow='\033[33m'
    c_red='\033[31m'
  else
    c_reset=''
    c_bold=''
    c_blue=''
    c_green=''
    c_yellow=''
    c_red=''
  fi
}

say() { printf '%b\n' "${c_blue}==>${c_reset} $*"; }
ok() { printf '%b\n' "${c_green}ok${c_reset}  $*"; }
warn() { printf '%b\n' "${c_yellow}warn${c_reset} $*"; }
die() { printf '%b\n' "${c_red}error${c_reset} $*" >&2; exit 1; }

redact_url() {
  case "$1" in
    *://*@*) printf '%s\n' "$1" | sed -E 's#(://)[^/@]+@#\1<redacted>@#' ;;
    *) printf '%s\n' "$1" ;;
  esac
}

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf '%b\n' "${c_yellow}dry-run${c_reset} $*"
  else
    "$@"
  fi
}

quiet_git() {
  git "$@" >/dev/null 2>&1
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --dry-run) dry_run=1 ;;
      --force) force=1 ;;
      --repo-url)
        [ "$#" -ge 2 ] || die "--repo-url requires a value"
        repo_url="$2"
        shift
        ;;
      --branch)
        [ "$#" -ge 2 ] || die "--branch requires a value"
        branch="$2"
        shift
        ;;
      --no-color) color_mode="never" ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown option: $1" ;;
    esac
    shift
  done
}

nearest_existing_parent() {
  p="$1"
  while [ ! -e "$p" ]; do
    next=$(dirname "$p")
    [ "$next" != "$p" ] || return 1
    p="$next"
  done
  [ -d "$p" ] || return 1
  printf '%s\n' "$p"
}

repo_slug() {
  url=${1%.git}
  case "$url" in
    git@github.com:*) printf '%s\n' "${url#git@github.com:}" ;;
    ssh://git@github.com/*) printf '%s\n' "${url#ssh://git@github.com/}" ;;
    https://github.com/*) printf '%s\n' "${url#https://github.com/}" ;;
    http://github.com/*) printf '%s\n' "${url#http://github.com/}" ;;
    *) printf '%s\n' "" ;;
  esac
}

is_same_repo_url() {
  a=${1%.git}
  b=${2%.git}
  [ "$a" = "$b" ] && return 0
  slug_a=$(repo_slug "$1")
  slug_b=$(repo_slug "$2")
  [ -n "$slug_a" ] && [ "$slug_a" = "$slug_b" ]
}

has_uncommitted_tracked_work() {
  git -C "$1" update-index -q --refresh >/dev/null 2>&1 || true
  git -C "$1" diff --quiet --ignore-submodules -- || return 0
  git -C "$1" diff --cached --quiet --ignore-submodules -- || return 0
  return 1
}

parse_json_file() {
  file=$1
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$file" <<'PY'
import json, pathlib, sys
json.loads(pathlib.Path(sys.argv[1]).read_text())
PY
  elif command -v node >/dev/null 2>&1; then
    node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$file"
  else
    return 2
  fi
}

verify_after_install() {
  say "Verifying installation"
  git -C "$target_dir" status --short
  ok "git status completed"

  for config_file in opencode-sample.jsonc opencode.jsonc; do
    if [ -f "$target_dir/$config_file" ]; then
      if parse_json_file "$target_dir/$config_file"; then
        ok "parsed $config_file"
      else
        rc=$?
        [ "$rc" -eq 2 ] && warn "skipped JSON parse for $config_file: python3 and node not found" || die "failed to parse $config_file"
      fi
    else
      warn "skipped JSON parse for missing $config_file"
    fi
  done

  if command -v opencode >/dev/null 2>&1; then
    if opencode debug config >/dev/null; then
      ok "opencode debug config completed"
    else
      die "opencode debug config failed"
    fi
  else
    warn "skipped opencode debug config: opencode not found"
  fi
}

parse_args "$@"
setup_color

target_parent=$(dirname "$target_dir")
timestamp=$(date +%Y%m%d-%H%M%S)
backup_dir="$target_parent/opencode.backup.$timestamp"
old_config_backup_name="opencode.jsonc.before-config-opencode-$timestamp"
existing_origin=""
target_state="absent"
action="clone"

say "Preflight checks"
ok "target: ${c_bold}$target_dir${c_reset}"
ok "repo: $(redact_url "$repo_url")"
ok "branch: $branch"

command -v git >/dev/null 2>&1 || die "git is required"
ok "git found"

existing_parent=$(nearest_existing_parent "$target_parent") || die "target parent is not creatable: $target_parent"
[ -w "$existing_parent" ] || die "cannot write to nearest existing parent: $existing_parent"
ok "target parent exists or is creatable"

[ ! -e "$backup_dir" ] || die "backup destination already exists: $backup_dir"
if [ -d "$target_parent" ]; then
  [ -w "$target_parent" ] || die "backup parent is not writable: $target_parent"
else
  [ -w "$existing_parent" ] || die "backup parent is not creatable: $target_parent"
fi
ok "backup destination is creatable"

case "$repo_url" in
  git@github.com:*|ssh://git@github.com/*)
    if command -v ssh >/dev/null 2>&1; then
      if ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com >/tmp/config-opencode-ssh-check.$$ 2>&1; then
        ok "GitHub SSH auth reachable"
      elif grep -qi "successfully authenticated" /tmp/config-opencode-ssh-check.$$; then
        ok "GitHub SSH auth reachable"
      else
        rm -f /tmp/config-opencode-ssh-check.$$
        quiet_git ls-remote --heads "$repo_url" "$branch" || die "cannot access SSH repo or branch"
        ok "GitHub SSH repo reachable via git ls-remote"
      fi
      rm -f /tmp/config-opencode-ssh-check.$$
    else
      quiet_git ls-remote --heads "$repo_url" "$branch" || die "ssh not found and git ls-remote failed"
      ok "GitHub SSH repo reachable via git ls-remote"
    fi
    ;;
  *)
    quiet_git ls-remote --heads "$repo_url" "$branch" || die "cannot access repo or branch"
    ok "repo reachable via git ls-remote"
    ;;
esac

if [ -e "$target_dir" ]; then
  if [ -d "$target_dir/.git" ] && quiet_git -C "$target_dir" rev-parse --is-inside-work-tree; then
    target_state="git-repo"
    existing_origin=$(git -C "$target_dir" remote get-url origin 2>/dev/null || true)
    if is_same_repo_url "$existing_origin" "$repo_url"; then
      action="update"
      ok "existing target is this repo"
    else
      action="backup-clone"
      ok "existing target is a different git repo and will be backed up"
    fi
    if has_uncommitted_tracked_work "$target_dir"; then
      [ "$force" -eq 1 ] || die "existing target repo has uncommitted tracked work; rerun with --force to continue"
      warn "existing target repo has uncommitted tracked work; --force allows continuing"
    fi
  elif [ -d "$target_dir" ]; then
    target_state="directory"
    action="backup-clone"
    ok "existing target is a non-repo directory and will be backed up"
  else
    target_state="file"
    action="backup-clone"
    ok "existing target is a file and will be backed up"
  fi
else
  ok "target does not exist and will be cloned"
fi

say "Plan"
case "$action" in
  update) ok "fast-forward existing repo, then ensure opencode.jsonc exists" ;;
  clone) ok "create parent if needed, clone repo, then ensure opencode.jsonc exists" ;;
  backup-clone) ok "move existing target to backup, clone repo, preserve old opencode.jsonc if present" ;;
esac

[ "$dry_run" -eq 1 ] && { say "Dry run complete; no changes made"; exit 0; }

say "Applying changes"
case "$action" in
  update)
    run git -C "$target_dir" fetch origin "$branch"
    run git -C "$target_dir" checkout "$branch"
    run git -C "$target_dir" pull --ff-only origin "$branch"
    ;;
  clone)
    run mkdir -p "$target_parent"
    run git clone --branch "$branch" --single-branch "$repo_url" "$target_dir"
    ;;
  backup-clone)
    run mkdir -p "$target_parent"
    run mv "$target_dir" "$backup_dir"
    run git clone --branch "$branch" --single-branch "$repo_url" "$target_dir"
    if [ -f "$backup_dir/opencode.jsonc" ]; then
      run cp "$backup_dir/opencode.jsonc" "$target_dir/$old_config_backup_name"
      ok "preserved old opencode.jsonc as $old_config_backup_name"
    fi
    ;;
  *) die "internal error: unknown action $action" ;;
esac

if [ ! -f "$target_dir/opencode.jsonc" ]; then
  [ -f "$target_dir/opencode-sample.jsonc" ] || die "opencode-sample.jsonc not found after install"
  run cp "$target_dir/opencode-sample.jsonc" "$target_dir/opencode.jsonc"
  ok "created opencode.jsonc from opencode-sample.jsonc"
else
  ok "opencode.jsonc already exists; left unchanged"
fi

verify_after_install
say "Install complete"
ok "target ready at $target_dir"
if [ "$target_state" != "absent" ] && [ "$action" = "backup-clone" ]; then
  ok "backup saved at $backup_dir"
fi
