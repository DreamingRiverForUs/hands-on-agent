#!/usr/bin/env bash

set -euo pipefail

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$project_root"

python3 examples/01_minimal_agent.py >/dev/null
python3 examples/02_safe_tools.py >/dev/null
python3 examples/03_eval_harness.py >/dev/null

test -s output/pdf/hands-on-agent.pdf
pdfinfo output/pdf/hands-on-agent.pdf | rg '^(Pages|Page size|PDF version):'

if rg -n '[[:blank:]]+$' --glob '*.tex' --glob '*.md' --glob '*.py' .; then
  printf 'Trailing whitespace found.\n' >&2
  exit 1
fi

if rg -n 'TODO_PLACEHOLDER|citation needed|待补引用' --glob '*.tex' --glob '*.md' .; then
  printf 'Unresolved manuscript placeholders found.\n' >&2
  exit 1
fi

printf 'All checks passed.\n'

