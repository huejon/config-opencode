#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

failures=0
PYTHON_BIN=""

section() {
  printf '\n== %s ==\n' "$1"
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  failures=$((failures + 1))
}

run_hard() {
  local description="$1"
  shift
  printf '+ %s\n' "$description"
  if ! "$@"; then
    fail "${description} failed"
  fi
}

run_optional() {
  local description="$1"
  shift
  printf '+ %s\n' "$description"
  if ! "$@"; then
    warn "${description} failed or is unavailable; continuing"
  fi
}

section "Required paths"
required_paths=(
  "AGENTS.md"
  "README.md"
  "commands/"
  "agents/"
  "references/"
  "skills/"
  "prompts/"
  "plugins/"
  "opencode-sample.jsonc"
  "scripts/validate-subagent-permissions.py"
)

for path in "${required_paths[@]}"; do
  if [[ -e "${path}" ]]; then
    printf 'OK %s\n' "${path}"
  else
    fail "missing required path: ${path}"
  fi
done

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
else
  fail "python3 or python is required for static validation"
fi

section "Subagent permissions"
if [[ -n "${PYTHON_BIN}" ]]; then
  run_hard "validate subagent permissions" "${PYTHON_BIN}" scripts/validate-subagent-permissions.py
fi

section "Git whitespace checks"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  run_hard "git diff --check" git diff --check
else
  warn "not inside a git worktree; skipping git diff --check"
fi

section "Command references"
if [[ -n "${PYTHON_BIN}" ]] && ! "${PYTHON_BIN}" - <<'PY'
from __future__ import annotations

from pathlib import Path
import re
import sys

root = Path.cwd()
errors: list[str] = []

def rel_exists(raw: str) -> bool:
    return (root / raw).exists()

for command in sorted((root / "commands").glob("*.md")):
    text = command.read_text(encoding="utf-8")

    # Command frontmatter agent references should map to a repo agent file.
    frontmatter = re.match(r"---\n(.*?)\n---", text, flags=re.S)
    if frontmatter:
        for match in re.finditer(r"^agent:\s*([A-Za-z0-9_-]+)\s*$", frontmatter.group(1), flags=re.M):
            agent = match.group(1)
            if not rel_exists(f"agents/{agent}.md"):
                errors.append(f"{command.relative_to(root)} references missing agent: agents/{agent}.md")

    # Repo-facing path literals in command bodies should exist when practical.
    candidates = set(re.findall(r"""[`'"]((?:agents|commands|references|scripts|skills|prompts)/[^`'"\s)]+)[`'"]""", text))
    for candidate in sorted(candidates):
        if not rel_exists(candidate):
            errors.append(f"{command.relative_to(root)} references missing path: {candidate}")

for error in errors:
    print(error, file=sys.stderr)

if errors:
    sys.exit(1)

print("Command agent/path references look valid.")
PY
then
  fail "command reference validation failed"
fi

section "Secret heuristics"
if [[ -n "${PYTHON_BIN}" ]] && ! "${PYTHON_BIN}" - <<'PY'
from __future__ import annotations

from pathlib import Path
import re
import subprocess
import sys

root = Path.cwd()
errors: list[str] = []

try:
    result = subprocess.run(["git", "ls-files"], cwd=root, check=True, text=True, capture_output=True)
    paths = [Path(line) for line in result.stdout.splitlines() if line]
except Exception:
    paths = [path.relative_to(root) for path in root.rglob("*") if path.is_file() and ".git" not in path.parts]

env_example_names = {".env.example", ".env.sample", ".env.template"}
secret_assignment = re.compile(
    r"(?i)(api[_-]?key|auth[_-]?token|access[_-]?token|refresh[_-]?token|secret[_-]?key|client[_-]?secret)\s*[:=]\s*['\"]?([^'\"\s#][^'\"\s#]{7,})"
)
private_key_header = re.compile(r"-----BEGIN [A-Z0-9 ]*PRIVATE KEY-----")
placeholder = re.compile(r"(?i)(example|sample|placeholder|changeme|change-me|dummy|test|token-here|your[_-]?(token|key|secret)|<[^>]+>|\{env:[A-Z0-9_]+\})")

for rel in paths:
    name = rel.name
    if name.startswith(".env") and name not in env_example_names:
        errors.append(f"committed env file: {rel}")

    path = root / rel
    try:
        raw = path.read_bytes()
    except OSError:
        continue
    if b"\0" in raw:
        continue
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError:
        continue

    for lineno, line in enumerate(text.splitlines(), start=1):
        if private_key_header.search(line):
            errors.append(f"private key header: {rel}:{lineno}")
        match = secret_assignment.search(line)
        if match and not placeholder.search(match.group(2)):
            errors.append(f"possible secret assignment: {rel}:{lineno}")

for error in errors:
    print(error, file=sys.stderr)

if errors:
    sys.exit(1)

print("No obvious committed secrets found.")
PY
then
  fail "secret heuristic validation failed"
fi

section "OpenCode debug checks"
if command -v opencode >/dev/null 2>&1; then
  run_optional "opencode --version" opencode --version
  run_optional "opencode debug config" opencode debug config
  run_optional "opencode debug paths" opencode debug paths
  run_optional "opencode debug agent work" opencode debug agent work
  run_optional "opencode debug agent question" opencode debug agent question
else
  warn "opencode is not installed or not on PATH; skipping OpenCode debug checks"
fi

section "Result"
if (( failures > 0 )); then
  printf 'Validation failed with %d hard failure(s).\n' "${failures}" >&2
  exit 1
fi

printf 'Validation passed.\n'
