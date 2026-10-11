#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

mkdir -p build/tmp

sagan_executable="$(bash scripts/resolve-sagan.sh)"
export SAGAN_PACKAGE_INDEX="$(bash scripts/resolve-physics.sh)"

native_tmp="$repo_root/build/tmp"
if command -v cygpath >/dev/null 2>&1; then
  native_tmp="$(cygpath -w "$native_tmp")"
fi

TMPDIR="$native_tmp" TMP="$native_tmp" TEMP="$native_tmp" \
  exec "$sagan_executable" src/main.sagan
