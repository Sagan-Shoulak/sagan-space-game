#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

sagan_executable="${SAGAN_EXECUTABLE:-$(bash scripts/resolve-sagan.sh)}"
fixture="$repo_root/build/resource-model-test"

mkdir -p "$fixture/src"
cp tests/fixtures/resource_model/sagan.toml "$fixture/sagan.toml"
cp tests/fixtures/resource_model/src/main.sagan "$fixture/src/main.sagan"
cp src/resources.sagan "$fixture/src/resources.sagan"
cp src/recipes.sagan "$fixture/src/recipes.sagan"

output="$($sagan_executable --run-package "$fixture")"
if [[ "$output" != *"Resource model test passed"* ]]; then
  echo "Resource model test did not report success" >&2
  echo "$output" >&2
  exit 1
fi

echo "$output"
