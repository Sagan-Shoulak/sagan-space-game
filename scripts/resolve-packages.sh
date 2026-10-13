#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
compiler_executable="$(bash "$repo_root/scripts/resolve-sagan.sh")"
physics_index="$(bash "$repo_root/scripts/resolve-physics.sh")"
render_root="$(bash "$repo_root/scripts/resolve-render.sh")"
sagan_pin="$(tr -d '\r\n' < "$repo_root/sagan-source-commit.txt")"
physics_pin="$(tr -d '\r\n' < "$repo_root/sagan-physics-commit.txt")"
render_pin="$(tr -d '\r\n' < "$repo_root/sagan-render-commit.txt")"
package_dir="$repo_root/build/package-index-${sagan_pin:0:8}-${physics_pin:0:8}-${render_pin:0:8}"
package_index="$package_dir/index.tsv"

compiler_source="$(cd "$(dirname "$compiler_executable")/.." && pwd)"
time_source="$compiler_source/libraries/time"
physics_source="$(cd "$(dirname "$physics_index")" && pwd)/physics"
render_source="$render_root/libraries/render"
[[ -f "$time_source/sagan.toml" ]]
[[ -f "$physics_source/sagan.toml" ]]
[[ -f "$render_source/sagan.toml" ]]

mkdir -p "$package_dir/time" "$package_dir/physics" "$package_dir/render"
cp -R "$time_source/." "$package_dir/time/"
cp -R "$physics_source/." "$package_dir/physics/"
cp -R "$render_source/." "$package_dir/render/"
printf 'sagan-package-index-v1\n' > "$package_index"
printf 'sagan-time\t0.1.0\t^4.0.0\tinstalled\ttime/sagan.toml\n' \
  >> "$package_index"
printf 'sagan-physics\t0.3.0\t^4.0.0\tinstalled\tphysics/sagan.toml\n' \
  >> "$package_index"
printf 'sagan-render\t0.5.1\t^4.0.0\tinstalled\trender/sagan.toml\n' \
  >> "$package_index"
printf '%s\n' "$package_index"
