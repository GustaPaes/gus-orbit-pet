#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
codex_home=${CODEX_HOME:-"$HOME/.codex"}
source_dir="$repo_root/pets/gus-orbit"
target_dir="$codex_home/pets/gus-orbit"

if [ ! -d "$source_dir" ]; then
  echo "Pet files were not found at $source_dir." >&2
  exit 1
fi

mkdir -p "$target_dir"
cp "$source_dir/pet.json" "$source_dir/spritesheet.webp" "$target_dir/"

echo "Gus Orbit was installed in $target_dir."
echo "To select it, set selected-avatar-id = \"gus-orbit\" in the [desktop] section of $codex_home/config.toml, then restart Codex Desktop."
