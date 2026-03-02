#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

usage() {
  cat <<'EOF'
Usage:
  ./build_all.sh [all|web|native] [release|debug]

Examples:
  ./build_all.sh
  ./build_all.sh web
  ./build_all.sh native release
  ./build_all.sh all debug
EOF
}

backend="${1:-all}"
profile="${2:-release}"

if [[ "$backend" != "all" && "$backend" != "web" && "$backend" != "native" ]]; then
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

native_games=()
while IFS= read -r game; do
  native_games+=("$game")
done < <(find native -mindepth 1 -maxdepth 1 -type d -not -name '.*' -exec basename {} \; | sort)

if [[ "$backend" == "all" || "$backend" == "web" ]]; then
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
fi

if [[ "$backend" == "all" || "$backend" == "native" ]]; then
  if [[ ${#native_games[@]} -eq 0 ]]; then
    echo "No native games found under examples/native"
    exit 1
  fi
  echo "Building native games (${profile})..."
  for game in "${native_games[@]}"; do
    echo "  - native/${game}"
    if [[ "$profile" == "release" ]]; then
      moon build "./native/${game}" --target native --release
    else
      moon build "./native/${game}" --target native
    fi
  done
fi

echo "Build complete."
