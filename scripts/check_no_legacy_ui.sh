#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_FILE="/tmp/selene-legacy-ui-check.txt"

patterns=(
  'Milky2018/selene/style'
  '@style'
  '\bUiSpace\b'
  '\bscreen_root\b'
  '\bvirtual_root\b'
  '\bviewport_root\b'
  '\bUI_ZINDEX\b'
  '\badd_node\s*\('
  '\badd_button\s*\('
  '\binteraction_event_bus\b'
  '\bset_overlay_space\b'
  '\bclear_overlay_space\b'
  '\bpush_overlay_text\b'
  '\boverlay_commands\b'
  '\bui_button_system\b'
  '\bglobal_ui_transforms\b'
  '\bui_transforms\b'
  '\buis\b'
)

exclude_globs=(
  '!**/_build/**'
  '!**/target/**'
  '!**/.moon/**'
  '!**/.mooncakes/**'
  '!**/.git/**'
  '!page/**'
  '!docs/CHANGELOG.md'
  '!**/pkg.generated.mbti'
  '!scripts/check_no_legacy_ui.sh'
)

cd "$ROOT_DIR"

status=0
if command -v rg >/dev/null 2>&1; then
  for pattern in "${patterns[@]}"; do
    if rg -n "$pattern" . "${exclude_globs[@]/#/--glob=}" >"$TMP_FILE"; then
      echo "Legacy UI symbol still present: $pattern" >&2
      cat "$TMP_FILE" >&2
      status=1
    fi
  done
else
  if ! python3 - "${patterns[@]}" <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(".")
patterns = sys.argv[1:]
excluded_dirs = {"_build", "target", ".moon", ".mooncakes", ".git", "page"}
excluded_files = {"CHANGELOG.md", "pkg.generated.mbti", "check_no_legacy_ui.sh"}
regexes = [(pattern, re.compile(pattern)) for pattern in patterns]
matches = {pattern: [] for pattern in patterns}

for path in root.rglob("*"):
    if not path.is_file():
        continue
    if any(part in excluded_dirs for part in path.parts):
        continue
    if path.name in excluded_files:
        continue
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except (OSError, UnicodeDecodeError):
        continue
    for index, line in enumerate(lines, start=1):
        for pattern, regex in regexes:
            if regex.search(line):
                matches[pattern].append(f"{path.as_posix()}:{index}:{line}")

status = 0
for pattern in patterns:
    entries = matches[pattern]
    if not entries:
        continue
    print(f"Legacy UI symbol still present: {pattern}", file=sys.stderr)
    for entry in entries:
        print(entry, file=sys.stderr)
    status = 1

sys.exit(status)
PY
  then
    status=1
  fi
fi

rm -f "$TMP_FILE"

if [[ "$status" -ne 0 ]]; then
  echo "Legacy UI guard failed. Migrate remaining old style/UI/overlay references." >&2
  exit "$status"
fi

echo "Legacy UI guard passed."
