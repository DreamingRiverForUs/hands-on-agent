# Local font dependencies

The book uses explicit Chinese and Latin font files to make PDF rendering consistent across preview applications.

Run:

```bash
make fonts
```

This downloads the following files from `https://cos.huimengxinhe.com/font/`:

- `simsun.ttc`: Chinese body text
- `simhei.ttf`: Chinese headings and bold text
- `simkai.ttf`: Chinese italic/emphasis text
- `times.ttf`, `timesbd.ttf`, `timesi.ttf`, `timesbi.ttf`: Latin text

The font binaries are intentionally excluded from Git. The download script pins their SHA-256 checksums, and CI downloads the same files before compilation. They are build dependencies supplied by an external host and may have redistribution restrictions. Confirm that you have the right to use them before distributing a compiled PDF.
