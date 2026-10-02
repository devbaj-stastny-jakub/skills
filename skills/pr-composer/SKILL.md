---
name: pr-composer
description: Compose and create/update a pull request from the branch, respecting the repository's policy and conventions. 
---

# Inputs (variables)
- `Source Branch`: branch which we are merging (optional)
- `Target Branch`: branch which we are merging `Source Branch` to (optional)

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

## 5. Compose description
Compose description for base diff using `references/pr.template.md`

## 6. Create/Update pull request
Create or update pull request based on resolved mode with new description and labels


## Guardrails
- Do not create duplicate pull requests
- Never mention AI authorship or contribution
- If anything is unclear, ask user for clarification

## Tools
Use `git` and `gh` cli. If anything is unavailable, ask user to resolve missing dependency.