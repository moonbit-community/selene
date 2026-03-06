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
  '!**/.git/**'
  '!page/**'
  '!docs/CHANGELOG.md'
  '!**/pkg.generated.mbti'
  '!scripts/check_no_legacy_ui.sh'
)

cd "$ROOT_DIR"

status=0
for pattern in "${patterns[@]}"; do
  if rg -n "$pattern" . "${exclude_globs[@]/#/--glob=}" >"$TMP_FILE"; then
    echo "Legacy UI symbol still present: $pattern" >&2
    cat "$TMP_FILE" >&2
    status=1
  fi
done

rm -f "$TMP_FILE"

if [[ "$status" -ne 0 ]]; then
  echo "Legacy UI guard failed. Migrate remaining old style/UI/overlay references." >&2
  exit "$status"
fi

echo "Legacy UI guard passed."
