# AGENTS.md

This repository is a Chinese LaTeX ebook project.

## Build

```bash
make fonts
make build
make render
make check
```

The stable PDF artifact is `output/pdf/hands-on-agent.pdf`. Temporary build and rendered-page files belong under `build/` and `tmp/pdfs/`.

## Font dependencies

The PDF must be compiled with the repository's explicit Chinese and Latin fonts. Before compiling, run `make fonts`. The `make build`, `make render`, and `make check` targets also download the fonts automatically through `scripts/download-fonts.sh`.

Required font files and download URLs:

- `simsun.ttc`: https://cos.huimengxinhe.com/font/simsun.ttc
- `simhei.ttf`: https://cos.huimengxinhe.com/font/simhei.ttf
- `simkai.ttf`: https://cos.huimengxinhe.com/font/simkai.ttf
- `times.ttf`: https://cos.huimengxinhe.com/font/times.ttf
- `timesbd.ttf`: https://cos.huimengxinhe.com/font/timesbd.ttf
- `timesi.ttf`: https://cos.huimengxinhe.com/font/timesi.ttf
- `timesbi.ttf`: https://cos.huimengxinhe.com/font/timesbi.ttf

Store these files under `font/`. Always use the download script so its pinned SHA-256 checksums are verified. Do not commit `.ttf` or `.ttc` binaries; they are external build dependencies and may have redistribution restrictions. After font or layout changes, run both `make check` and `make render`, then inspect the rendered PNG pages for missing glyphs, boxes, overlap, or misalignment.

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
