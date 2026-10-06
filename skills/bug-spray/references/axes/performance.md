# performance

Does the change make the system slow, wasteful, or fragile at realistic load and data size?

## Look for
- Database: N+1, queries in loops, missing pagination/limits, new query patterns without an index, `SELECT *` on wide tables in hot paths, long lock-holding transactions.
- Algorithms: quadratic or worse over growing data (nested loops, `find`/`includes` in loops), repeated expensive work that could run once.
- Memory: whole tables/files/streams in memory, unbounded caches or arrays, leaks (listeners, timers, subscriptions).
- I/O: blocking I/O on hot paths, sequential awaits that could be parallel, network calls without timeouts, chatty APIs.
- Frontend: needless re-renders of large trees, unstable props/keys, heavy work in render, big bundles for small features, layout thrashing.
- Concurrency: unbounded parallelism (`Promise.all` over user-sized arrays), missing backpressure.

## Method
- State the scale that makes it matter, with evidence: table size, list length, call frequency, user-controlled size. No scale, no finding.
- Check hot path (handler, render, loop) vs cold (startup, one-off script, admin task).
- No micro-optimizations.

## Not yours
- Attacker-driven DoS: security.
- Wrong results: correctness.
