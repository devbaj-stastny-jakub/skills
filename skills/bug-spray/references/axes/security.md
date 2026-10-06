# security

Can the change be abused, or does it expose what it shouldn't?

## Look for
- Injection: SQL/NoSQL, command, template, LDAP, header, log.
- Authn/authz: missing or weakened checks, IDOR, privilege escalation, trusting client-supplied roles or IDs.
- Secrets in code, config, logs, error messages, client bundles.
- Web: XSS, CSRF, open redirect, SSRF, insecure CORS, missing security headers the app sets elsewhere.
- Files: path traversal, unrestricted upload, zip slip.
- Parsing: unsafe deserialization, prototype pollution, XXE, ReDoS.
- Crypto: weak algorithms, hardcoded IVs/salts, non-constant-time secret comparison, home-made crypto.
- Data exposure: sensitive or personal data in responses, logs, analytics, caches.
- Trust boundaries: unvalidated input from users, webhooks, queues, third parties.
- Dependencies: new packages that are unmaintained, typosquat-looking, or from unusual sources.

## Method
- Trace **source to sink**, citing each hop. No traced path = hypothesis, not finding.
- Check existing defences on the path (validation middleware, ORM parameterization, framework escaping).
- Name the attacker and what they need (anonymous, logged-in user, admin, another service).

## Not yours
- Hardening with no reachable exploit path.
- Bugs without security impact: correctness.
