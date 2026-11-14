---
name: pr-pit-stop
description: Address unresolved code review comments on a pull request - validate, discuss one at a time, fix and reply
disable-model-invocation: true
---

The goal is to fix what code review found on a pull request and answer the reviewer.

## Inputs (variables)

- `Pull Request`: number or URL (optional, default PR of current branch)

## Steps

### Step 1

Read all unresolved review comments - regular and inline. Skip resolved ones.

### Step 2

Validate each comment against the codebase. Is the problem real? Does it still apply to current code?

### Step 3

Present comments to the user one at a time. For each:

- briefly describe the problem
- propose action: **fix** or **ignore**
- for fix, show how it should be fixed
- for ignore, say why

Keep it brief. The user asks to elaborate when something is unclear. Wait for the user's decision before moving to the next one.

### Step 4

Once all comments are walked through, fix the agreed ones.

### Step 5

Reply to each comment with a single brief line. No formalities, keep it targeted to the technical scope. Inline comments get a reply in their thread. Show drafted replies to the user before posting.
