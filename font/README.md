# Local font dependencies

The book uses explicit Chinese and Latin font files to make PDF rendering consistent across preview applications.

Run:

```bash
make fonts
```

This downloads the following files:

- [`simsun.ttc`](https://cos.huimengxinhe.com/font/simsun.ttc): Chinese body text
- [`simhei.ttf`](https://cos.huimengxinhe.com/font/simhei.ttf): Chinese headings and bold text
- [`simkai.ttf`](https://cos.huimengxinhe.com/font/simkai.ttf): Chinese italic/emphasis text
- [`times.ttf`](https://cos.huimengxinhe.com/font/times.ttf): Latin regular text
- [`timesbd.ttf`](https://cos.huimengxinhe.com/font/timesbd.ttf): Latin bold text
- [`timesi.ttf`](https://cos.huimengxinhe.com/font/timesi.ttf): Latin italic text
- [`timesbi.ttf`](https://cos.huimengxinhe.com/font/timesbi.ttf): Latin bold italic text

The font binaries are intentionally excluded from Git. The download script pins their SHA-256 checksums, and CI downloads the same files before compilation. They are build dependencies supplied by an external host and may have redistribution restrictions. Confirm that you have the right to use them before distributing a compiled PDF.
