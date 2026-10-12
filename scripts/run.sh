#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
mkdir -p build/game build/tmp

sagan_executable="$(bash scripts/resolve-sagan.sh)"
render_root="$(bash scripts/resolve-render.sh)"
if [[ -z "${SAGAN_PACKAGE_INDEX:-}" ]]; then
  export SAGAN_PACKAGE_INDEX="$(bash scripts/resolve-packages.sh)"
fi

"$sagan_executable" --emit-cpp-package . build/game/program.cpp

host_os="$(uname -s)"
case "$host_os" in
  MINGW*|MSYS*|CYGWIN*)
    sdl_root="$(bash "$render_root/scripts/fetch-sdl3-windows.sh")"
    if [[ "$sdl_root" != /* ]]; then
      sdl_root="$(cd "$render_root/$sdl_root" && pwd)"
    fi
    icon_resource="$($sagan_executable --application-icon windows)"
    native_tmp="$repo_root/build/tmp"
    if command -v cygpath >/dev/null 2>&1; then
      native_tmp="$(cygpath -w "$native_tmp")"
    fi
    TMPDIR="$native_tmp" TMP="$native_tmp" TEMP="$native_tmp" \
      g++ -std=c++23 -Wall -Wextra -Wpedantic -Werror \
      -DSAGAN_RENDER_UI_BRIDGE \
      -include "$render_root/libraries/render/native/ui_gpu_bridge.hpp" \
      -I"$sdl_root/include" build/game/program.cpp \
      "$render_root/examples/ui_gpu_demo.cpp" "$icon_resource" \
      -L"$sdl_root/lib" -lSDL3 -o build/game/space-game.exe
    cp "$sdl_root/bin/SDL3.dll" build/game/SDL3.dll
    game_executable="$repo_root/build/game/space-game.exe"
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
    read -r -a sdl_cflags <<< "$(pkg-config --cflags sdl3)"
    read -r -a sdl_libs <<< "$(pkg-config --libs sdl3)"
    g++ -std=c++23 -Wall -Wextra -Wpedantic -Werror \
      -DSAGAN_RENDER_UI_BRIDGE \
      -include "$render_root/libraries/render/native/ui_gpu_bridge.hpp" \
      "${sdl_cflags[@]}" build/game/program.cpp \
      "$render_root/examples/ui_gpu_demo.cpp" "${sdl_libs[@]}" \
      -o build/game/space-game
    game_executable="$repo_root/build/game/space-game"
    ;;
  *)
    echo "error: scripts/run.sh currently supports Windows and Linux" >&2
    exit 1
    ;;
esac

export SAGAN_RENDER_DEMO_KIND=surface
export SAGAN_RENDER_SHADER_ROOT="$render_root/shaders/generated/material"
cd "$render_root"
exec "$game_executable"
