# AGENTS.md

This repository is a Chinese LaTeX ebook project.

## Build

```bash
make build
make render
make check
```

The stable PDF artifact is `output/pdf/hands-on-agent.pdf`. Temporary build and rendered-page files belong under `build/` and `tmp/pdfs/`.

## Writing conventions

- Write original Chinese explanations; link and cite primary sources.
- Every technical chapter should include learning goals, a practical task, failure modes, exercises, and a completion checklist.
- Prefer model- and framework-agnostic principles before framework-specific examples.
- Do not copy third-party tutorials, course text, diagrams, or README sections into the book.
- Keep code examples runnable with the Python standard library unless a chapter explicitly introduces a dependency.
- Add citations to `references.bib`; do not leave raw research notes or unverifiable claims in the manuscript.
- Preserve the content/code license split described in `README.md`.

## Layout conventions

- Use environments defined in `config/style.tex`: `definitionbox`, `takeaway`, `practice`, `warningbox`, and `checkpoint`.
- Use `booktabs` tables and avoid vertical table rules.
- Keep diagrams in TikZ when they are simple enough to remain editable.
- Compile and render representative pages after meaningful layout changes.

