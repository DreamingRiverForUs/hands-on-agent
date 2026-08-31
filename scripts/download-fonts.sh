#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
font_dir="$project_root/font"
base_url="https://cos.huimengxinhe.com/font"

font_files=(
  simsun.ttc
  simhei.ttf
  simkai.ttf
  times.ttf
  timesbd.ttf
  timesi.ttf
  timesbi.ttf
)

font_hashes=(
  1526ac24375f51f6eb73bc2d3f8072dbe4a80a3a65217677c9d9a84f67dab2ab
  9b1959db3b3abeb7efdaec26edf7dfe871a6039de8d614af7248575207be629e
  95b3e69321f4e55f6ecf36b29d1e31a0c1205acfde0117df6472a17494c3cbd2
  fbb57cdb0079137adc0e478913ca134dfee02aa2ef443738ec5e839bf97a1f7f
  e94ff9111656f17bd81e9f822f1e234edcd370bcbacfdebf998b8938f525ac77
  c2c134968be4259aaa78845d3aca5e91c4a0bd10d98e4d2e48ac3c12f3c63b89
  8d2c8d8d25d9fc529d08558c42effa771617914a455603881e212a26e2f2ddcd
)

file_hash() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d ' ' -f 1
  else
    shasum -a 256 "$1" | cut -d ' ' -f 1
  fi
}

mkdir -p "$font_dir"

for index in "${!font_files[@]}"; do
  font_file="${font_files[$index]}"
  expected_hash="${font_hashes[$index]}"
  destination="$font_dir/$font_file"
  if [[ -s "$destination" ]] && [[ "$(file_hash "$destination")" == "$expected_hash" ]]; then
    printf 'Using cached font %s\n' "$font_file"
    continue
  fi

  temporary="$destination.download"
  rm -f "$temporary"
  printf 'Downloading %s\n' "$font_file"
  curl --fail --location --retry 3 --silent --show-error \
    "$base_url/$font_file" --output "$temporary"
  actual_hash=$(file_hash "$temporary")
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    rm -f "$temporary"
    printf 'Checksum mismatch for %s\n' "$font_file" >&2
    exit 1
  fi
  mv "$temporary" "$destination"
done

printf 'Fonts are ready in %s\n' "$font_dir"
