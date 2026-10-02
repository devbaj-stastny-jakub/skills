# Authoring skills

## Structure

Each skill lives in `skills/<skill-name>/`:

```
skills/<skill-name>/
├── SKILL.md        required — frontmatter + instructions
├── references/     optional — longer docs loaded on demand
├── scripts/        optional — helper scripts the skill runs
└── assets/         optional — templates, examples, static files
```

## SKILL.md frontmatter

```yaml
---
name: skill-name          # kebab-case, matches folder name
description: ...          # what it does + when to trigger it
---
```

## Conventions

- Folder name = `name` in frontmatter, kebab-case.
- `description` is the trigger: state what the skill does and the phrases/situations that should invoke it.
- Keep `SKILL.md` focused; move long reference material into `references/` and link to it.
- Scripts must be executable and documented in `SKILL.md`.
- Add the skill to the table in the root `README.md`.

## Testing

1. `./scripts/install.sh <skill-name>`
2. Start a new Claude Code session.
3. Trigger the skill with a prompt matching its description and check it loads and behaves as expected.
