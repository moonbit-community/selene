#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

usage() {
  cat <<'EOF'
Usage:
  ./build_all.sh [web] [release|debug]

Examples:
  ./build_all.sh
  ./build_all.sh web
  ./build_all.sh web release
EOF
}

backend="${1:-web}"
profile="${2:-release}"

if [[ "$backend" != "web" ]]; then
  usage
  exit 1
fi

if [[ "$profile" != "release" && "$profile" != "debug" ]]; then
  usage
  exit 1
fi

web_games=()
while IFS= read -r game; do
  web_games+=("$game")
done < <(find web -mindepth 1 -maxdepth 1 -type d -not -name '.*' -exec basename {} \; | sort)

if [[ ${#web_games[@]} -eq 0 ]]; then
  echo "No web games found under examples/web"
  exit 1
fi

echo "Building web games (${profile})..."
for game in "${web_games[@]}"; do
  echo "  - web/${game}"
  if [[ "$profile" == "release" ]]; then
    moon build "./web/${game}" --target js --release
  else
    moon build "./web/${game}" --target js
  fi
done

echo "Build complete."
