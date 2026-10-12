#!/usr/bin/env bash
set -euo pipefail

game_executable="${1:?Pass the freshly built Space Game executable}"
render_root="${2:?Pass the exact pinned renderer root}"
output_dir="${3:-build/shackleton-view-test}"

game_executable="$(cd "$(dirname "$game_executable")" && pwd)/$(basename "$game_executable")"
render_root="$(cd "$render_root" && pwd)"
output_dir="$(mkdir -p "$output_dir" && cd "$output_dir" && pwd)"
baseline="$output_dir/baseline.bmp"
input="$output_dir/input.bmp"

cd "$render_root"
export SAGAN_RENDER_SHADER_ROOT="$render_root/shaders/generated/material"
# Fit hosted desktop bounds so both captures exercise the same viewport.
export SAGAN_RENDER_LOGICAL_WIDTH=960 SAGAN_RENDER_LOGICAL_HEIGHT=540
SAGAN_RENDER_DEMO_KIND=surface \
SAGAN_RENDER_AUTOCLOSE_MS=500 \
SAGAN_RENDER_UI_CAPTURE_BMP="$baseline" \
  "$game_executable"

SAGAN_RENDER_DEMO_KIND=surface \
SAGAN_RENDER_AUTOCLOSE_MS=500 \
SAGAN_RENDER_TEST_ORBIT_DX=90 \
SAGAN_RENDER_TEST_ORBIT_DY=45 \
SAGAN_RENDER_TEST_ORBIT_AFTER_MS=100 \
SAGAN_RENDER_UI_CAPTURE_BMP="$input" \
  "$game_executable"

[[ -s "$baseline" ]]
[[ -s "$input" ]]
for capture in "$baseline" "$input"; do
  dimensions="$(od -An -td4 -j18 -N8 "$capture" | tr -s ' ' | sed 's/^ //;s/ $//')"
  [[ "$dimensions" == "960 540" ]] || {
    echo "Unexpected capture dimensions: $dimensions (expected 960 540)" >&2
    exit 1
  }
done
cmp "$baseline" "$input"
echo "Shackleton view test passed: the rendered local scene ignores camera input."
