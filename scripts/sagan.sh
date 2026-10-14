#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
compiler="$(bash "$repo_root/scripts/resolve-sagan.sh")"

if [[ -z "${SAGAN_PACKAGE_INDEX:-}" ]]; then
  package_index="$(bash "$repo_root/scripts/resolve-packages.sh")"
  export SAGAN_PACKAGE_INDEX="$package_index"
fi

exec "$compiler" "$@"
