#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
pdf_file="$project_root/output/pdf/hands-on-agent.pdf"
render_dir="$project_root/tmp/pdfs/rendered"

rm -rf "$render_dir"
mkdir -p "$render_dir"

render_log="$project_root/tmp/pdfs/render.log"
if command -v pdftoppm >/dev/null 2>&1; then
  pdftoppm -png -r 120 "$pdf_file" "$render_dir/page" \
    >/dev/null 2>"$render_log" || true
fi

if ! find "$render_dir" -name '*.png' -print -quit | rg -q . || \
  rg -q 'Missing language pack|Unknown font tag|No font in show' "$render_log" 2>/dev/null; then
  command -v gs >/dev/null 2>&1 || {
    printf 'Rendering requires pdftoppm or Ghostscript.\n' >&2
    exit 1
  }
  rm -f "$render_dir"/*.png
  gs -q -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r120 \
    -sOutputFile="$render_dir/page-%02d.png" "$pdf_file"
  printf 'Poppler could not map embedded CJK fonts; used Ghostscript fallback.\n'
fi

printf 'Rendered pages to %s\n' "$render_dir"
