---
name: pr-projector
description: Build a visual artifact of a pull request's high-level concepts (design, logic flows, architecture, data model, decisions, risks) for human code review. Use when the user says "pr-projector", "project/visualize this PR", or wants a visual overview of changes before reviewing them.
---

The goal is to project a pull request into diagrams, so a human reviewer grasps its concepts before reading the diff.

Diagrams carry the message, not text. A diagram that needs a paragraph to be understood is the wrong diagram.

## Inputs (variables)

- `Pull Request`: number, URL or branch (optional, default PR of current branch, else current branch vs its base)
- `Focus`: area or question the reviewer cares about (optional)

## Steps

### Step 1

Read PR title, description, commits, linked issue or spec and the full diff with `git` and `gh`. Read code around the diff too. For big PRs, split exploration into subagents by area.

### Step 2

Pick concepts the reviewer would otherwise have to reconstruct in their head - architecture, flows, state, data, decisions, risks. Skip what doesn't apply. A small PR may need one diagram.

### Step 3

Draw a diagram per concept - module graph, sequence, state, ER, flowchart. Mark new and changed parts. Every box and arrow must trace to code.

### Step 4

Annotate only what the diagram can't show: why, hidden invariants, side effects, risks. One line each, attached to the node or step it explains, with a code link pinned to head SHA. No summaries, no captions restating the diagram, no prose sections.

### Step 5

Build a single static HTML page, title on top, then diagrams. No JavaScript UI. Load `artifact-design` and `artifact-diagramming` skills if available. Publish with `Artifact` tool and return the link.

## Guardrails

- Read-only. Never touch the PR
- No line-level review
- No invented behaviour. Inferred is marked inferred
- No secrets or `.env*` content
