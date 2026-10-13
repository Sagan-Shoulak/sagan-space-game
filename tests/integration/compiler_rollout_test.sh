#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

sagan_executable="${SAGAN_EXECUTABLE:-$(bash scripts/resolve-sagan.sh)}"
if [[ -z "${SAGAN_PACKAGE_INDEX:-}" ]]; then
  export SAGAN_PACKAGE_INDEX="$(bash scripts/resolve-packages.sh)"
fi

output="$($sagan_executable --run-package tests/fixtures/compiler_rollout)"
if [[ "$output" != *"Compiler rollout test passed"* ]]; then
  echo "Compiler rollout fixture did not report success" >&2
  echo "$output" >&2
  exit 1
fi

echo "$output"
