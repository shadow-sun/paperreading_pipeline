# paper-lab

```text
paper-lab/
  papers/<paper>/                原文
    <paper>.pdf                    原文 PDF
    fulltext.md                    结构化 Markdown/LaTeX 全文
    (图)
  notes/<paper>/<paper>.md       论文卡片（结构见下）
  notes/<paper>/notation.md      符号表（只汇总公式，公式后解释变量）
  notes/concepts/<概念>.md       跨论文概念笔记
  notes/datasets/<数据集名>.md    数据集笔记（标题 = 数据集名，tag = 主题，可多 tag）
  code/<paper>/                  官方代码 + 你的复现（仅少量论文）
  code/<paper>/REPRO.md          复现日志：差异、trace、指标对齐
  profile/learner.md             你的能力画像（喂给 AI）
  index.md                       全库看板（Dataview）
  AGENTS.md                      给 Agent 的全局约定
  templates/                     各类模板
```

paper-card（六节）：
0 一句话 / 1 五问 / 2 关键假设（列表）/ 3 方法（公式 + 变量解释）/ 4 关键实验与数据 / 5 关联
（公式一律用 `$$...$$` 块级显示，Obsidian 才渲染；伪代码仅在原文给出 Algorithm 时生成）

疑问不单独建文件：就地写在卡片 / 符号表 / 概念笔记的相关位置。

命名与链接：
- 卡片文件名 = `<作者><年份> - <标题>`，所以 `[[<paper>]]` 直接指向卡片。
- 同篇的卫星文件用相对链接：`[符号表](notation.md)`。
- 概念用 `[[<概念名>]]`，与卡片互相链接。
- 数据集用 `[[<数据集名>]]`：文件名 = 数据集名，tag = 主题（audit / privacy-protection / memory 等，可多 tag），统一加 `dataset` tag。

code 根据重要程度进行安排，仅少量论文进行复现。
