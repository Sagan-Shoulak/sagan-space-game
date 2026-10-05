# Space Game agent rules

Read `SPACE_GAME_DESIGN.md` for goals, then `CODEX_START.md` once if present,
followed by `TECHNOLOGY.md` and `MAINTAINERS.md` for context and operations.
The first chat removes the tracked bootstrap prompt through a PR; do not
recreate it. These guides and the versioned ecosystem/chat maps remain
durable. Ask the owner clarifying
questions freely. Never treat old chats or prototype code as sources of
new game goals.

Use Bash commands for the owner, never PowerShell. Preserve the shared
sandbox and both recorded local snapshots. Follow the branch, focused-test,
`dev` integration, full-suite-on-`main`, documentation-review reset, and
release-hold rules in `MAINTAINERS.md`. The owner prefers to be taught what
to write; implement only on explicit request.

Use issues for substantive work, linked PRs into `dev`, and the organization
Project for cross-repo milestones when accessible. Record focused gameplay
checks, dependency pins, and integration impact; track blocked Project access
in the issue.

Route by owner: `sagan` language/toolchain, `sagan-vscode` editor,
`sagan-physics` numeric physics, `sagan-render` rendering,
`sagan-workspace` exact-lock integration, `sagan-docs` official site, and
`sagan-space-game` application/design. Handoffs to another chat must include
goal, evidence, constraints, pins, and verification. Only the design document
and direct owner answers define game goals.
