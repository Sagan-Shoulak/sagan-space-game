#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "Sagan compiler resolution failed: $*" >&2
  exit 1
}

if [[ -n "${SAGAN_EXECUTABLE:-}" ]]; then
  resolved="$(command -v "$SAGAN_EXECUTABLE" 2>/dev/null || true)"
  [[ -n "$resolved" && -x "$resolved" ]] || \
    fail "SAGAN_EXECUTABLE is not executable: $SAGAN_EXECUTABLE"
  printf '%s\n' "$resolved"
  exit 0
fi

pin_file="${SAGAN_SOURCE_PIN_FILE:-$repo_root/sagan-source-commit.txt}"
[[ -f "$pin_file" ]] || fail "missing source pin: $pin_file"
pin="$(tr -d '\r\n' < "$pin_file")"
[[ "$pin" =~ ^[0-9a-f]{40}$ ]] || \
  fail "source pin must be one lowercase 40-character Git commit"

short_pin="${pin:0:8}"
cache_base="${SAGAN_COMPILER_CACHE_ROOT:-$repo_root/build}"
source_root="$cache_base/sagan-pinned-$short_pin"
executable_name="sagan"
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) executable_name="sagan.exe" ;;
esac
cached_executable="$source_root/bin/$executable_name"
built_pin_file="$source_root/.sagan-built-commit"

command -v git >/dev/null 2>&1 || \
  fail "'git' is required to fetch pinned Sagan $short_pin"
make_command="$(command -v make 2>/dev/null || true)"
if [[ -z "$make_command" && -x /c/msys64/usr/bin/make.exe ]]; then
  make_command=/c/msys64/usr/bin/make.exe
fi
[[ -n "$make_command" ]] || \
  fail "'make' is required to build pinned Sagan $short_pin"

mkdir -p "$cache_base"
if [[ -e "$source_root" && ! -d "$source_root/.git" ]]; then
  incomplete="$source_root.incomplete-$(date +%s)"
  echo "Preserving incomplete compiler cache as $incomplete" >&2
  mv "$source_root" "$incomplete"
fi

if [[ -x "$cached_executable" ]]; then
  cached_pin="$(git -C "$source_root" rev-parse HEAD 2>/dev/null || true)"
  built_pin=""
  if [[ -f "$built_pin_file" ]]; then
    built_pin="$(tr -d '\r\n' < "$built_pin_file")"
  fi
  if [[ "$cached_pin" == "$pin" && "$built_pin" == "$pin" ]]; then
    echo "Using cached Sagan compiler for $short_pin." >&2
    printf '%s\n' "$cached_executable"
    exit 0
  fi
fi

if [[ ! -d "$source_root/.git" ]]; then
  echo "Fetching pinned Sagan compiler source $short_pin..." >&2
  git clone --no-checkout https://github.com/Sagan-Shoulak/sagan.git \
    "$source_root" >&2
fi

echo "Preparing exact Sagan source commit $pin..." >&2
git -C "$source_root" fetch origin "$pin" >&2
git -C "$source_root" checkout --detach "$pin" >&2

if [[ -x "$cached_executable" ]]; then
  echo "Discarding unverified cached compiler artifact for $short_pin..." >&2
  "$make_command" -C "$source_root" clean >&2
fi

jobs="${SAGAN_BUILD_JOBS:-2}"
[[ "$jobs" =~ ^[1-9][0-9]*$ ]] || \
  fail "SAGAN_BUILD_JOBS must be a positive integer"
echo "Building pinned Sagan compiler with $jobs jobs..." >&2
"$make_command" -C "$source_root" -j"$jobs" bin/sagan >&2

[[ -x "$cached_executable" ]] || \
  fail "build completed without producing $cached_executable"
printf '%s\n' "$pin" > "$built_pin_file"
echo "Pinned Sagan compiler is ready at $cached_executable" >&2
printf '%s\n' "$cached_executable"
