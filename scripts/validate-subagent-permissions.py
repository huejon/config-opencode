#!/usr/bin/env python3
"""Validate hardened permissions for review/judge/risk subagents."""

from __future__ import annotations

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
AGENT_DIR = ROOT / "agents"
TARGETS = sorted(
    [*AGENT_DIR.glob("review-*.md"), *AGENT_DIR.glob("judge*.md"), AGENT_DIR / "red-team.md", AGENT_DIR / "blue-team.md"]
)

DENIED_FLAT_TOOLS = {
    "edit",
    "task",
    "todowrite",
    "skill",
    "question",
    "external_directory",
}
ALLOWED_FLAT_TOOLS = {"webfetch", "websearch"}
READ_ONLY_GIT = ["git status*", "git diff*", "git log*", "git show*"]


def frontmatter(path: Path) -> list[str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        raise ValueError("missing opening frontmatter fence")
    try:
        end = lines.index("---", 1)
    except ValueError as exc:
        raise ValueError("missing closing frontmatter fence") from exc
    return lines[1:end]


def flat_value(lines: list[str], key: str) -> str | None:
    prefix = f"  {key}: "
    for line in lines:
        if line.startswith(prefix):
            return line.removeprefix(prefix).strip()
    return None


def bash_entries(lines: list[str]) -> list[tuple[str, str]]:
    entries: list[tuple[str, str]] = []
    in_bash = False
    for line in lines:
        if line == "  bash:":
            in_bash = True
            continue
        if in_bash:
            if not line.startswith("    "):
                break
            raw_key, sep, raw_value = line.strip().partition(":")
            if not sep:
                raise ValueError(f"invalid bash permission line: {line!r}")
            entries.append((raw_key.strip().strip('"\''), raw_value.strip()))
    return entries


def validate(path: Path) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")
    if re.search(r"(?<![A-Za-z])ask(?![A-Za-z])", text):
        errors.append("contains standalone 'ask'")

    try:
        fm = frontmatter(path)
    except ValueError as exc:
        return [str(exc)]

    for tool in ALLOWED_FLAT_TOOLS:
        if flat_value(fm, tool) != "allow":
            errors.append(f"{tool} is not allow")

    for tool in DENIED_FLAT_TOOLS:
        if flat_value(fm, tool) != "deny":
            errors.append(f"{tool} is not deny")

    bash = bash_entries(fm)
    if ("*", "deny") not in bash:
        errors.append("bash wildcard is not deny")
    wildcard_index = next((idx for idx, entry in enumerate(bash) if entry == ("*", "deny")), -1)
    for pattern in READ_ONLY_GIT:
        if (pattern, "allow") not in bash:
            errors.append(f"missing bash allow for {pattern}")
        elif wildcard_index >= 0 and bash.index((pattern, "allow")) < wildcard_index:
            errors.append(f"{pattern} allow appears before wildcard deny")

    for pattern, action in bash:
        if action == "ask":
            errors.append(f"bash {pattern} resolves to ask")

    return errors


def main() -> int:
    missing = [str(path.relative_to(ROOT)) for path in TARGETS if not path.exists()]
    if missing:
        print("Missing target agents:", ", ".join(missing), file=sys.stderr)
        return 1

    failures: dict[str, list[str]] = {}
    for path in TARGETS:
        errors = validate(path)
        if errors:
            failures[str(path.relative_to(ROOT))] = errors

    if failures:
        for path, errors in failures.items():
            print(f"{path}:", file=sys.stderr)
            for error in errors:
                print(f"  - {error}", file=sys.stderr)
        return 1

    print(f"Validated {len(TARGETS)} review/judge/risk agents.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
