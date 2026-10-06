# Packs

One file of checkable rules per technology or area (React, Nest.js, Prisma, ...). Orchestrator picks applying packs; each reviewer in `axes` reads only its own section.

`references/packs/<name>.md`:

```markdown
---
name: react
applies_when: diff touches *.tsx or *.jsx, or package.json depends on react
axes: [quality, performance, tests]
---

# React

## quality
- Rule a reviewer can check, with the cost of breaking it.

## performance
- ...

## tests
- ...
```

- `applies_when`: plain-language condition, checked against `files.txt` and manifests in the code root.
- `axes`: subset of `correctness`, `quality`, `domain`, `tests`, `security`, `performance`. One `##` section each.
- Rules specific and checkable: "Hooks must not be called conditionally", not "write clean components".
