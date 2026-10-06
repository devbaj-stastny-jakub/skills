# correctness

Does the changed code behave right for every realistic input and state?

## Look for
- Logic: wrong condition, operator, or variable; inverted check; off-by-one.
- Edge cases: null/undefined/empty, zero, negative, boundaries, unicode, time zones, huge input.
- Errors: swallowed, wrong type, missing cleanup, partial writes left behind, retries duplicating effects.
- Async: missing `await`, races, unhandled rejections, shared mutable state, ordering assumptions.
- State: stale caches, invalid transitions, shared-object mutation, lifecycle bugs.
- Contracts: changed signature, return shape, defaults, or semantics callers rely on.
- Data: lost updates, wrong or irreversible migrations, inconsistent writes across stores.
- Library misuse: wrong arguments, deprecated behaviour, misread return values.

## Method
- Trace one hop past the diff both ways (callers, callees). Bugs hide in unchanged code.
- Contract change: check every caller.
- Compare with `BASE` to confirm the behaviour is new.

## Not yours
- Exploitable impact, incl. exploitable bugs: security.
- Speed, resources: performance.
- Business rules vs ADRs, glossary, intent: domain.
