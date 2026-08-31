# 动手学 Agent

一本面向中文学习者的开源实践电子书：从 Agent 的基本循环出发，逐步实现工具调用、上下文工程、记忆、RAG、MCP、多 Agent、评测、安全与生产化。

当前版本：`v0.1.0-draft`

## 阅读

- PDF：[output/pdf/hands-on-agent.pdf](output/pdf/hands-on-agent.pdf)
- 书稿入口：[book.tex](book.tex)
- 章节目录：[chapters/](chapters/)
- 可运行示例：[examples/](examples/)

## 这本书的原则

1. 先做能工作的最小 Agent，再引入框架。
2. 先定义任务和验收标准，再讨论模型与工具。
3. 把环境反馈、失败恢复、权限和评测当作主体，而不是上线前的附录。
4. 每一章都留下可运行产物，不把“看懂”误认为“会做”。
5. 资源导航只链接原始来源，不收录盗版课程和来源不明的网盘文件。

## 构建

推荐安装 Tectonic；构建脚本会用它自动下载所需 TeX 包并完成参考文献与目录编译。若未安装 Tectonic，则回退到 XeLaTeX、latexmk 与 BibTeX。渲染检查需要 Poppler 的 `pdftoppm`，中文字体映射不可用时会自动回退 Ghostscript；元数据检查使用 `pdfinfo`。

```bash
make build
```

输出：`output/pdf/hands-on-agent.pdf`

macOS 可通过 Homebrew 安装推荐工具：

```bash
brew install tectonic poppler ghostscript
```

渲染全部页面为 PNG：

```bash
make render
```

运行代码、PDF 和书稿检查：

```bash
make check
```

## 项目结构

```text
hands-on-agent/
├── book.tex                  # 全书入口
├── config/style.tex          # 字体、配色、章节和提示框样式
├── chapters/                 # 正文章节
├── appendices/               # 资源地图、术语与检查表
├── examples/                 # 可运行 Python 示例
├── references.bib            # 一手资料和论文
├── scripts/                  # 构建与检查脚本
├── output/pdf/               # 稳定 PDF 产物
└── tmp/pdfs/                 # 页面渲染等临时文件
```

## 贡献

请先阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。新增内容应解决明确的学习问题，并提供原始来源、实践任务和验收方式。

## 许可

- 书稿、排版和原创图表：CC BY-NC-SA 4.0，见 [LICENSE-CONTENT.md](LICENSE-CONTENT.md)。
- `examples/`、`scripts/` 和 CI 配置：MIT，见 [LICENSE-CODE](LICENSE-CODE)。
- 引用、链接和第三方项目仍归各自作者所有，并受各自许可证约束。

## 维护

本书由 `DreamingRiverForUs` 维护。路线图和待写内容使用 GitHub Issues 管理；稳定里程碑以 GitHub Releases 发布 PDF。
