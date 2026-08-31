#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$project_root"

python3 examples/01_minimal_agent.py >/dev/null
python3 examples/02_safe_tools.py >/dev/null
python3 examples/03_eval_harness.py >/dev/null

test -s output/pdf/hands-on-agent.pdf
pdfinfo output/pdf/hands-on-agent.pdf | rg '^(Pages|Page size|PDF version):'

if command -v pdftoppm >/dev/null 2>&1; then
  font_check_dir=tmp/pdfs/font-check
  font_check_log=tmp/pdfs/font-check.log
  rm -rf "$font_check_dir"
  mkdir -p "$font_check_dir"
  if ! pdftoppm -f 1 -singlefile -png -r 72 output/pdf/hands-on-agent.pdf \
    "$font_check_dir/page" >/dev/null 2>"$font_check_log"; then
    cat "$font_check_log" >&2
    exit 1
  fi
  if rg -q 'Missing language pack|Unknown font tag|No font in show' "$font_check_log"; then
    cat "$font_check_log" >&2
    printf 'PDF contains CJK fonts that Poppler cannot render.\n' >&2
    exit 1
  fi
fi

if rg -n '[[:blank:]]+$' --glob '*.tex' --glob '*.md' --glob '*.py' .; then
  printf 'Trailing whitespace found.\n' >&2
  exit 1
fi

if rg -n 'TODO_PLACEHOLDER|citation needed|待补引用' --glob '*.tex' --glob '*.md' .; then
  printf 'Unresolved manuscript placeholders found.\n' >&2
  exit 1
fi

printf 'All checks passed.\n'
