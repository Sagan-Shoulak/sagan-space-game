#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if [[ $# -ne 0 ]]; then
  echo "Usage: bash scripts/rebuild.sh" >&2
  exit 2
fi

mkdir -p build/tmp

sagan_executable="$(bash scripts/resolve-sagan.sh)"
physics_root="$(bash scripts/resolve-physics.sh)"
render_root="$(bash scripts/resolve-render.sh)"
package_index="$(bash scripts/resolve-packages.sh)"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    bash "$render_root/scripts/fetch-sdl3-windows.sh" >/dev/null
    ;;
  Linux)
    if ! command -v pkg-config >/dev/null 2>&1; then
      echo "error: pkg-config is required to build Space Game" >&2
      exit 1
    fi
    if ! pkg-config --atleast-version=3.4.16 sdl3; then
      echo "error: SDL3 3.4.16 or newer is required to build Space Game" >&2
      exit 1
    fi
    ;;
  Darwin)
    bash "$render_root/scripts/build-sdl3-source.sh" >/dev/null
    ;;
  *)
    echo "error: scripts/rebuild.sh supports Windows, Linux, and macOS" >&2
    exit 1
    ;;
esac

printf 'Dependencies ready:\n'
printf '  compiler: %s\n' "$sagan_executable"
printf '  physics: %s\n' "$physics_root"
printf '  renderer: %s\n' "$render_root"
printf '  packages: %s\n' "$package_index"
