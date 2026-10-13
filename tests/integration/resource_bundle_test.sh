#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

sagan_executable="${SAGAN_EXECUTABLE:-$(bash scripts/resolve-sagan.sh)}"
fixture="$repo_root/build/resource-bundle-test"

mkdir -p "$fixture/src"
cp tests/fixtures/resource_bundle/sagan.toml "$fixture/sagan.toml"
cp tests/fixtures/resource_bundle/src/main.sagan "$fixture/src/main.sagan"
cp src/resources.sagan "$fixture/src/resources.sagan"

output="$($sagan_executable --run-package "$fixture")"
if [[ "$output" != *"ResourceBundle test passed"* ]]; then
  echo "ResourceBundle fixture did not report success" >&2
  echo "$output" >&2
  exit 1
fi

echo "$output"
