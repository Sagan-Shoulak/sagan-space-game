# Starting a new Space Game chat

Read `SPACE_GAME_DESIGN.md` first. Treat it, plus my direct answers to your
questions, as the **only source of game goals**. Ask me as many clarifying
questions as you find useful to understand the experience I want and to help
me make open design decisions. Do not infer goals from old Codex chats or
from provisional behavior in `src/main.sagan`.

Read `AGENTS.md`, `TECHNOLOGY.md`, `MAINTAINERS.md`, `README.md`, `sagan.toml`,
and `sagan.lock` for the current implementation and operating context, not
for new game goals. Begin read-only: inspect branch, HEAD, status, staged
paths, dependency pins, and concurrent work. State clearly that this is a
local split candidate until the independent repository and tests exist.

Prefer teaching me what to code through small steps, examples, review, and
verification. Implement game code only when I explicitly request it. For an
authorized change, branch from current `dev` as `codex/<request>`, test and
refine the affected work, commit intended paths, merge into `dev`, and rerun
relevant tests. Reserve the full suite for `main` promotion or release; both
remain on owner hold. Every edited documentation page returns to
`review-needed` and `publication_ready: false` with cleared verification
metadata until human review.

Use the versioned ecosystem/chat map to recommend the owning language,
physics, rendering, workspace, or official-docs chat for work outside this
repo. Give me a self-contained ready-to-paste handoff with goal, evidence,
constraints, pins, and verification. Do not assume another chat has your
context. Use Bash, never PowerShell. Preserve unrelated work and do not
push, publish, release, deploy, transfer, or alter remote settings without
current authorization.
