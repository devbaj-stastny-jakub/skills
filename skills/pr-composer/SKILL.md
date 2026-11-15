---
name: pr-composer
description: Compose and create/update a pull request from the branch, respecting the repository's policy and conventions. 
---

# Inputs (variables)
- `Source Branch`: branch which we are merging (optional)
- `Target Branch`: branch which we are merging `Source Branch` to (optional)
- `Draft`: create pull request as draft (optional, default false). `Create` mode only

# Modes
- `Create` - pull request does not exist yet
- `Update` - pull request already exists

# Workflow

## 1. Resolve source and target branches

### Source Branch
If `Source Branch` is not specified, pick current branch.

### Target Branch
If `Target Branch` is not specified, there are two options:
1. It is the one, that `Source Branch` was created from
2. It is default branch for this repository (commonly main or master)

Always ask user which one is correct using interactive interface

## 2. Resolve mode
If there is opened pull request with current combination of `Source Branch` and `Target Branch`, resolve to `Update` mode. Otherwise, resolve to `Create` mode

## 3. Read content
Read all commits and complete base diff to understand, what are the changes about

## 4. Resolve labels
Get list of all available labels from repository and pick appropriate ones. Do not invent new labels.

## 5. Upload visual evidence
Skip unless the diff changes something visible.

GitHub has no API for image attachments. Commit screenshots to a dedicated `pr-evidence` branch through the GitHub Contents API using `gh`, never touching the local working tree. Create the branch if it does not exist. Embed images by raw URL pinned to the upload commit SHA, so later uploads never change what an older PR shows.

- Use screenshots taken for this change in this session; `playwright-cli` saves them to `.playwright-cli/` by default. If there are none, ask user to provide them.
- View each image before uploading. Upload only ones that show the change, and none exposing secrets, tokens or real personal data: everyone with repository access can read the branch.
- Never put local file paths into the description; they do not render.

## 6. Compose description
Compose description for base diff using `references/pr.template.md`

## 7. Create/Update pull request
Create or update pull request based on resolved mode with new title, description and labels. With `Draft`, create it as draft. Update never changes draft state


## Guardrails
- Do not create duplicate pull requests
- Never mention AI authorship or contribution
- If anything is unclear, ask user for clarification

## Tools
Use `git` and `gh` cli. If anything is unavailable, ask user to resolve missing dependency.