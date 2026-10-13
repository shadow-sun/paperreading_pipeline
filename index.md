# 论文库索引

> 结构说明见 [[README]]；AI 协作约定见 [[AGENTS]]。
> 下方表格由 Dataview **自动生成**，不要手改表格内容。

## 阅读中

```dataview
TABLE year AS 年份, venue AS 会议, file.mtime AS 更新
FROM "notes"
WHERE contains(file.tags, "#paper") AND status = "reading"
SORT file.mtime DESC
```

## 全部论文

```dataview
TABLE year AS 年份, status AS 状态, venue AS 会议
FROM "notes"
WHERE contains(file.tags, "#paper")
SORT year DESC
```

## 概念

```dataview
LIST
FROM "notes/concepts"
SORT file.name ASC
```
