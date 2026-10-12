#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "Sagan render resolution failed: $*" >&2
  exit 1
}

pin_file="${SAGAN_RENDER_PIN_FILE:-$repo_root/sagan-render-commit.txt}"
[[ -f "$pin_file" ]] || fail "missing renderer pin: $pin_file"
pin="$(tr -d '\r\n' < "$pin_file")"
[[ "$pin" =~ ^[0-9a-f]{40}$ ]] || \
  fail "renderer pin must be one lowercase 40-character Git commit"

short_pin="${pin:0:8}"

if [[ -n "${SAGAN_RENDER_SOURCE_ROOT:-}" ]]; then
  source_root="$(cd "$SAGAN_RENDER_SOURCE_ROOT" && pwd)"
  [[ -f "$source_root/libraries/render/sagan.toml" ]] || \
    fail "override does not contain the renderer package: $source_root"
  override_pin="$(git -C "$source_root" rev-parse HEAD 2>/dev/null || true)"
  [[ "$override_pin" == "$pin" ]] || \
    fail "override is $override_pin, expected exact pin $pin"
  printf '%s\n' "$source_root"
  exit 0
fi

cache_base="${SAGAN_RENDER_CACHE_ROOT:-$repo_root/build}"
source_root="$cache_base/sagan-render-pinned-$short_pin"
package_manifest="$source_root/libraries/render/sagan.toml"

command -v git >/dev/null 2>&1 || \
  fail "'git' is required to fetch pinned Sagan render $short_pin"

mkdir -p "$cache_base"
if [[ -e "$source_root" && ! -d "$source_root/.git" ]]; then
  incomplete="$source_root.incomplete-$(date +%s)"
  echo "Preserving incomplete renderer cache as $incomplete" >&2
  mv "$source_root" "$incomplete"
fi

if [[ -f "$package_manifest" ]]; then
  cached_pin="$(git -C "$source_root" rev-parse HEAD 2>/dev/null || true)"
  if [[ "$cached_pin" == "$pin" ]]; then
    echo "Using cached Sagan renderer for $short_pin." >&2
    printf '%s\n' "$source_root"
    exit 0
  fi
fi

if [[ ! -d "$source_root/.git" ]]; then
  echo "Fetching pinned Sagan renderer source $short_pin..." >&2
  git clone --no-checkout https://github.com/Sagan-Shoulak/sagan-render.git \
    "$source_root" >&2
fi

echo "Preparing exact Sagan renderer commit $pin..." >&2
git -C "$source_root" fetch origin "$pin" >&2
git -C "$source_root" checkout --detach "$pin" >&2

[[ -f "$package_manifest" ]] || \
  fail "checkout does not contain $package_manifest"
echo "Pinned Sagan renderer is ready at $source_root" >&2
printf '%s\n' "$source_root"
