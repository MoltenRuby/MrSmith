---
name: programmer-behaviour-rules
description: Standard pre-coding behaviour rules for programmer agents — read before writing, match
  conventions, no new dependencies without reason, explain before refactoring, ask before assuming,
  and clean test design (no tautological tests, mocks only at architectural boundaries)
license: MIT
compatibility: opencode
---

## Behaviour rules

- Before writing any code, read the relevant existing files to understand conventions in use.
- Match the style, naming conventions, and module patterns already present in the codebase.
- Do not introduce new dependencies without stating the reason and asking for confirmation.
- When refactoring, explain what changes and why before making the changes.
- If a requirement is ambiguous, ask one clarifying question before proceeding.

## Test design

### No tautological tests

A tautological test asserts the implementation rather than the behaviour. It has no diagnostic value
and breaks when the code is restructured even if the behaviour is unchanged.

Forbidden patterns:

- Asserting that a mock was called (e.g. `mock.assert_called_once_with(...)`,
  `expect(spy).toHaveBeenCalledWith(...)`) when the call is an internal implementation detail —
  not an observable output or a boundary side-effect.
- Asserting return values that merely echo constructor arguments with no transformation.
- Tests whose only assertion is the absence of an exception thrown by a mock.

Required: every test must assert observable behaviour — a return value, a visible state change, an
event emitted, or a boundary call that constitutes the feature's contract.

### Mocks only at architectural boundaries

Mocks, stubs, and spies are legitimate **only** at architectural boundaries. A boundary is any point
where the code crosses out of the process or into infrastructure it does not own.

Approved boundary list (mock here):

- **I/O** — file system reads/writes, stdin/stdout/stderr
- **CLI** — subprocess invocations, shell commands
- **Network / web service calls** — HTTP clients, gRPC stubs, WebSocket connections
- **Databases / data access** — SQL, NoSQL, ORM sessions, query builders
- **Message queues / event buses** — Kafka, RabbitMQ, SQS, pub/sub producers/consumers
- **Clock / time** — `datetime.now()`, `Date.now()`, `time.time()`, system timers
- **Randomness** — `random`, `uuid`, `crypto.randomBytes`, any non-deterministic value source
- **External services** — payment gateways, email senders, SMS providers, third-party APIs

Not a boundary — do not mock:

- Domain services, use cases, application services
- In-process repositories backed by in-memory data structures (use a real in-memory fake instead)
- Pure functions and value objects
- Internal collaborators within the same module or package

### Fakes and in-memory implementations are always preferred over mocks

When a dependency is an interface or abstract type (repository, gateway, port), provide a concrete
in-memory fake that satisfies the contract. Fakes are first-class code: they are tested, they enforce
the interface, and they enable fast, deterministic integration tests without mocks.

### No monkey-patching of internal collaborators

Do not use patching/monkey-patching mechanisms (e.g. `unittest.mock.patch`, `jest.spyOn`,
`sinon.stub`) to replace non-boundary collaborators during tests. This creates invisible coupling
between the test and the implementation structure.
