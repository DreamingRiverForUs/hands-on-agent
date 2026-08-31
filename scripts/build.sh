#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$project_root"

mkdir -p build output/pdf

if command -v tectonic >/dev/null 2>&1; then
  tectonic -X compile book.tex --outdir build --keep-logs
elif command -v latexmk >/dev/null 2>&1; then
  latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
    -outdir=build book.tex
else
  printf 'Build requires Tectonic or latexmk with XeLaTeX.\n' >&2
  exit 1
fi

cp build/book.pdf output/pdf/hands-on-agent.pdf

printf 'Built %s\n' "$project_root/output/pdf/hands-on-agent.pdf"
