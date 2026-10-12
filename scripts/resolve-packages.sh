#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
physics_index="$(bash "$repo_root/scripts/resolve-physics.sh")"
render_root="$(bash "$repo_root/scripts/resolve-render.sh")"
physics_pin="$(tr -d '\r\n' < "$repo_root/sagan-physics-commit.txt")"
render_pin="$(tr -d '\r\n' < "$repo_root/sagan-render-commit.txt")"
package_dir="$repo_root/build/package-index-${physics_pin:0:8}-${render_pin:0:8}"
package_index="$package_dir/index.tsv"

physics_source="$(cd "$(dirname "$physics_index")" && pwd)/physics"
render_source="$render_root/libraries/render"
[[ -f "$physics_source/sagan.toml" ]]
[[ -f "$render_source/sagan.toml" ]]

mkdir -p "$package_dir/physics" "$package_dir/render"
cp -R "$physics_source/." "$package_dir/physics/"
cp -R "$render_source/." "$package_dir/render/"
printf 'sagan-package-index-v1\n' > "$package_index"
printf 'sagan-physics\t0.3.0\t^4.0.0\tinstalled\tphysics/sagan.toml\n' \
  >> "$package_index"
printf 'sagan-render\t0.5.1\t^4.0.0\tinstalled\trender/sagan.toml\n' \
  >> "$package_index"
printf '%s\n' "$package_index"
