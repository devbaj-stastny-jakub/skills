# domain

Does the change fit the domain model, decisions, and stated intent?

## Sources
Domain docs in `context.md`:
- `CONTEXT.md` / `CONTEXT-MAP.md`: glossary, bounded contexts. With a map, use the `CONTEXT.md` of the changed code's context.
- ADRs (`adr/`, `adrs/`, `decisions/`), `GLOSSARY.md`, `ARCHITECTURE.md`.
- Intent: branch name in `meta.md`, `commits.txt`.

No docs: still check intent vs code, and terms vs how existing code names the same concepts.

## Look for
- ADR violation: contradicts an accepted ADR. Quote decision and file. Superseded ADRs don't count.
- Glossary: term used with a different meaning, new synonym for an existing concept, two concepts conflated (Customer vs User), term marked as avoided.
- Invariants: business rule stated in docs or enforced elsewhere is broken or bypassed.
- Bounded contexts: one context reaches into another's internals instead of its public interface.
- Intent vs code: commits say X; code does something else, part of X, or X plus unannounced changes.

## Not yours
- Naming taste unrelated to domain: quality, only with concrete cost.
- Technical bugs: correctness.
