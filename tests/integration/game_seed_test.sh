#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

if [[ -z "${SAGAN_PACKAGE_INDEX:-}" ]]; then
  echo "Set SAGAN_PACKAGE_INDEX to a reviewed physics package catalog." >&2
  exit 2
fi

output="$("${SAGAN_EXECUTABLE:-sagan}" src/main.sagan)"
for expected in "Sol:" "Earth:" "Luna:" "Pluto:" "Ceres:" "Halley's Comet:" "Distances: Sol to..."; do
  if [[ "$output" != *"$expected"* ]]; then
    echo "Missing Space Game seed output: $expected" >&2
    echo "$output" >&2
    exit 1
  fi
done

echo "Space Game seed test passed: the pinned physics package ran the six-body summary."
