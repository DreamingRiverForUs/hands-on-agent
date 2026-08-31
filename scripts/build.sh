#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$project_root"

mkdir -p build output/pdf
latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
  -outdir=build book.tex
cp build/book.pdf output/pdf/hands-on-agent.pdf

printf 'Built %s\n' "$project_root/output/pdf/hands-on-agent.pdf"

