#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
pdf_file="$project_root/output/pdf/hands-on-agent.pdf"
render_dir="$project_root/tmp/pdfs/rendered"

rm -rf "$render_dir"
mkdir -p "$render_dir"

render_log="$project_root/tmp/pdfs/render.log"
if command -v pdftoppm >/dev/null 2>&1; then
  if ! pdftoppm -png -r 120 "$pdf_file" "$render_dir/page" \
    >/dev/null 2>"$render_log"; then
    cat "$render_log" >&2
    exit 1
  fi
  if rg -q 'Missing language pack|Unknown font tag|No font in show' "$render_log"; then
    cat "$render_log" >&2
    printf 'PDF contains CJK fonts that Poppler cannot render.\n' >&2
    exit 1
  fi
else
  command -v gs >/dev/null 2>&1 || {
    printf 'Rendering requires pdftoppm or Ghostscript.\n' >&2
    exit 1
  }
  gs -q -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r120 \
    -sOutputFile="$render_dir/page-%02d.png" "$pdf_file"
fi

find "$render_dir" -name '*.png' -print -quit | rg -q . || {
  printf 'Renderer produced no PNG pages.\n' >&2
  exit 1
}

printf 'Rendered pages to %s\n' "$render_dir"
