#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0

check_absent() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if rg -n --pcre2 "$pattern" "$root/$path" >/tmp/selene_webgpu_ffi_audit_matches.$$; then
    echo "webgpu thin-ffi audit failed: $label"
    cat /tmp/selene_webgpu_ffi_audit_matches.$$
    failed=1
  fi
  rm -f /tmp/selene_webgpu_ffi_audit_matches.$$
}

check_absent "selene-webgpu/src/canvas.mbt" 'code:\s*`' "WGSL template literals must stay in MoonBit shader_sources.mbt"
check_absent "selene-webgpu/src/canvas.mbt" 'lightShadowStructsWgsl|shadowSamplingWgsl' "shared WGSL assembly must stay in MoonBit"
check_absent "selene-webgpu/src" 'directionalLights|pointLights|spotLights|rt\.light3d|light3d:\s*\{' "WebGPU JS must not rebuild full light objects"
check_absent "selene-webgpu/src/js_render2d.mbt" '\.sort\s*\(' "shadow cascade ordering must stay in MoonBit packet order"

if (( failed != 0 )); then
  exit 1
fi

echo "webgpu thin-ffi audit passed"
