---
name: babysit-spec
description: Autonomously implement tickets of specification and test behavior of implementation
disable-model-invocation: true
---

The goal is to implement provided spec with its tickets.

The tickets are not a list of steps. They are a task graph with blocking relationships between them. This means there is always a frontier of tickets which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through context pointers: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

Steps should run in subagents everywhere where possible to maximize utilization of clear context and concurrency.

Fully autonomous after preflight. Ask the user only during preflight.

## Preflight

1. **Skills**: check if you have all necessary skills - `tdd`, `code-review`, `bug-spray`, `pr-composer`. If something missing -> stop and prompt user
2. **Worktree**: ask user if he wants to run in a separate worktree or stay in place. If worktree, call `EnterWorktree` tool.

## Steps

### Step 1

Read the spec and tickets to understand the task graph

### Step 2

Create **integration branch** `babysit/<YYYYMMDD-HHMMSS>`

### Step 3

Loop those steps until whole spec is implemented

1. pick frontier of available tickets
2. implement ticket in its own worktree on its on branch. each implementer subagent:

- confirms its worktree is based on integration branch
- calls skill `tdd` to implement the ticket
- runs typechecking, single test files regularly and full test suite once at the end
- once done, use `code-review` skill to review work

3. once an implementer subagent completes, merge its work to the integration branch with a merger subagent
4. if frontier of tickets changes, run more implementer subagents to ensure maximum concurrency

### Step 4

Once all tickets are implemented, run `bug-spray` on integration branch. Run fixer subagent for each issue found

### Step 5

Kick off tester subagent to test functional behavior of spec implementation. Use available tooling for interactive e2e testing like fetch tools, browser testing tools and others

### Step 6

Run fixer subagent for each issue found by tester subagent. Repeat steps 5 and 6 until all issues are resolved or until you hit max of 5 iterations.

### Step 7

Cleanup all implementer subagent worktrees

### Step 8

Rename implementation branch according to repository standards and create draft pull requests using `pr-composer` skill
