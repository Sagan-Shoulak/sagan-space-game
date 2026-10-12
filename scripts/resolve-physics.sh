#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "Sagan physics resolution failed: $*" >&2
  exit 1
}

if [[ -n "${SAGAN_PACKAGE_INDEX:-}" ]]; then
  [[ -f "$SAGAN_PACKAGE_INDEX" ]] || \
    fail "SAGAN_PACKAGE_INDEX is not a file: $SAGAN_PACKAGE_INDEX"
  index_dir="$(cd "$(dirname "$SAGAN_PACKAGE_INDEX")" && pwd)"
  printf '%s/%s\n' "$index_dir" "$(basename "$SAGAN_PACKAGE_INDEX")"
  exit 0
fi

pin_file="${SAGAN_PHYSICS_PIN_FILE:-$repo_root/sagan-physics-commit.txt}"
[[ -f "$pin_file" ]] || fail "missing physics pin: $pin_file"
pin="$(tr -d '\r\n' < "$pin_file")"
[[ "$pin" =~ ^[0-9a-f]{40}$ ]] || \
  fail "physics pin must be one lowercase 40-character Git commit"

short_pin="${pin:0:8}"

if [[ -n "${SAGAN_PHYSICS_SOURCE_ROOT:-}" ]]; then
  source_root="$(cd "$SAGAN_PHYSICS_SOURCE_ROOT" && pwd)"
  package_index="$source_root/libraries/index.tsv"
  [[ -f "$package_index" ]] || \
    fail "override does not contain the physics package: $source_root"
  override_pin="$(git -C "$source_root" rev-parse HEAD 2>/dev/null || true)"
  [[ "$override_pin" == "$pin" ]] || \
    fail "override is $override_pin, expected exact pin $pin"
  printf '%s\n' "$package_index"
  exit 0
fi

cache_base="${SAGAN_PHYSICS_CACHE_ROOT:-$repo_root/build}"
source_root="$cache_base/sagan-physics-pinned-$short_pin"
package_index="$source_root/libraries/index.tsv"

command -v git >/dev/null 2>&1 || \
  fail "'git' is required to fetch pinned Sagan physics $short_pin"

mkdir -p "$cache_base"
if [[ -e "$source_root" && ! -d "$source_root/.git" ]]; then
  incomplete="$source_root.incomplete-$(date +%s)"
  echo "Preserving incomplete physics cache as $incomplete" >&2
  mv "$source_root" "$incomplete"
fi

if [[ -f "$package_index" ]]; then
  cached_pin="$(git -C "$source_root" rev-parse HEAD 2>/dev/null || true)"
  if [[ "$cached_pin" == "$pin" ]]; then
    echo "Using cached Sagan physics package for $short_pin." >&2
    printf '%s\n' "$package_index"
    exit 0
  fi
fi

if [[ ! -d "$source_root/.git" ]]; then
  echo "Fetching pinned Sagan physics source $short_pin..." >&2
  git clone --no-checkout https://github.com/Sagan-Shoulak/sagan-physics.git \
    "$source_root" >&2
fi

echo "Preparing exact Sagan physics commit $pin..." >&2
git -C "$source_root" fetch origin "$pin" >&2
git -C "$source_root" checkout --detach "$pin" >&2

[[ -f "$package_index" ]] || \
  fail "checkout does not contain $package_index"
echo "Pinned Sagan physics package is ready at $package_index" >&2
printf '%s\n' "$package_index"
