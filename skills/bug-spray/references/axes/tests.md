# tests

Test **quality**, not coverage. Do tests in and around the change prove what they claim, and would they fail if it broke?

Good test: verifies behaviour through a public interface, reads like a spec ("user can checkout with valid cart"), survives refactors.

## Look for
- Tautological: expected value computed like the code computes it (`expect(add(a, b)).toBe(a + b)`, a `reduce` mirroring the implementation, constant equal to itself, hand-built matching snapshot). Expected values need an independent source: literal, worked example, spec.
- Implementation-coupled: mocks internal collaborators, tests private methods, asserts call counts/order, breaks on refactor without behaviour change.
- Side-channel: checks DB row, file, or internal field instead of the interface (`createUser` then `SELECT` instead of `getUser`).
- Mocking own modules: mock only system boundaries (external APIs, time, randomness, sometimes DB or file system).
- Over-mocking hides a bug: mock returns what the real dependency never would.
- Name says HOW not WHAT: `calls paymentService.process`.
- Broken or hollowed: tests, mocks, fixtures, snapshots out of sync with the change; assertions removed or loosened; tests skipped or deleted without reason.
- Assertion gaps: name claims behaviour the assertions don't check; only "no error thrown".
- Flaky: real time, sleeps, unordered result order, shared state, network.
- Risky untested change: money, auth, deletion, migrations, complex branching with no test that would fail. Name behaviour and path. Never generic "add tests" or coverage numbers.

## Method
- Read changed tests and tests of changed production code (by import/filename).
- Suspected hollow test: mentally break the production code. Test still passes = evidence.

## Not yours
- Production bugs: correctness.
- Test style without concrete cost.
