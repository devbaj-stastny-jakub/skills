# skills

Personal collection of [Claude Code](https://claude.com/claude-code) skills for my own workflows.

## Layout

```
skills/      one folder per skill, each with a SKILL.md
docs/        authoring notes and conventions
scripts/     helper scripts (install, etc.)
```

## Skills

| Skill | Description |
| ----- | ----------- |
| [pr-composer](skills/pr-composer/SKILL.md) | Compose and create/update a pull request from the branch, respecting the repository's policy and conventions. |

## Install

Symlink every skill into `~/.claude/skills` so edits here take effect immediately:

```sh
./scripts/install.sh            # link all skills
./scripts/install.sh my-skill   # link only selected skills
```

Existing non-symlink entries in `~/.claude/skills` are never overwritten.

## New skill

```sh
cp -r templates/skill skills/<skill-name>
```

Then edit `skills/<skill-name>/SKILL.md`. See [docs/authoring.md](docs/authoring.md).

## License

[MIT](LICENSE)
