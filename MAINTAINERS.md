---
title: Maintaining Space Game
status: review-needed
publication_ready: false
verified_in: null
verified_on: null
verified_by: null
---

# Maintaining Space Game

This is a public split repository. `SPACE_GAME_DESIGN.md` owns the game goals;
`src/main.sagan` is a prototype seed. The installed-toolchain test and
release pipeline remain unverified. Do not present this source as a game
release.

## Reproduce the current focused check

Independent seed CI checks out exact language, physics, and renderer commits
from the three `sagan-*-commit.txt` files, builds the compiler, emits the
windowed `src/game.sagan` application package, then runs the numeric seed in
`src/main.sagan` directly on Linux and Windows using
`bash tests/integration/game_seed_test.sh`. These source pins
are a temporary CI path while released package
consumption is paused; they do not certify a game release. Keep the lockfile
and package versions compatible when changing any pin.

From the repository root in Git Bash, build and run the windowed game with:

```bash
bash scripts/run.sh
```

On the first run, `scripts/resolve-sagan.sh` clones the exact commit in
`sagan-source-commit.txt`, builds it under ignored
`build/sagan-pinned-<commit>/`, and reuses that compiler on later runs.
`scripts/resolve-physics.sh` likewise clones the exact commit in
`sagan-physics-commit.txt` under ignored
`build/sagan-physics-pinned-<commit>/`. `scripts/resolve-render.sh` clones the
exact `sagan-render-commit.txt` commit under
`build/sagan-render-pinned-<commit>/`; `scripts/resolve-packages.sh` composes
both packages into an ignored relative-path catalog. The launcher emits and
links one native windowed executable using the renderer's SDL resolver. An
incomplete cache is preserved with an `.incomplete-<timestamp>` suffix rather
than overwritten. The first run requires network access, Git, Make, curl,
unzip, and the compiler prerequisites for Sagan and the renderer. On Windows,
run from an MSYS2 UCRT64 Git Bash environment so the native compiler is
available.

Set `SAGAN_EXECUTABLE`, `SAGAN_PACKAGE_INDEX`,
`SAGAN_PHYSICS_SOURCE_ROOT`, or `SAGAN_RENDER_SOURCE_ROOT` only for an explicit
reviewed override. Every source-root override must match its exact pin.
`SAGAN_BUILD_JOBS` controls compiler build parallelism and defaults to `2`.
A successful `bash scripts/run.sh` opens the separate `src/game.sagan` entry
directly into the fixed local Shackleton Base view and continues until the
window closes. The standalone numeric fixture
still advances fourteen 0.1-second steps, reaches 35 watt-seconds of stored
charge with 86 kilograms each of water, food, and oxygen, then exits zero.
The manifest currently names the package `Sandbox`, retained from the seed;
rename it only after the owner chooses the game's package identity.

`sagan.toml` declares the physics and rendering dependencies, and `sagan.lock`
selects their current versions. Do not silently replace a released package with a sibling
checkout. Use the workspace's exact lock and record any local override when
testing across repositories. Build outputs belong in ignored `build/`.

## Change workflow and ownership

Inspect branch, HEAD, status, staged paths, and the relevant design section
before changing files. For each authorized request, branch from current
`dev` as `codex/<request>`. Test the affected change and refine until it
works, commit only intended paths, merge into `dev`, and rerun relevant tests
against integrated work. Run the full suite only for a reviewed `dev` to
`main` promotion or release. Both promotion and releases are currently held
until the owner explicitly reopens them and decides publication policy.

Do not run unrelated executable documentation examples for a structural-only
documentation change. Any edited documentation page returns to
`status: review-needed`, `publication_ready: false`, and null verification
metadata until a human audit. If a change belongs to the language, physics,
rendering, workspace, or official-docs owner, hand it to the specialized chat
with a self-contained prompt rather than duplicating implementation here.

## Preservation and recovery

The candidate's `src/main.sagan` came from the newly preserved October 5
snapshot, SHA-256
`545cf284f287698c45bb50ca4737d6dff9755e45f791d8ad4971bf9e70a51533`.
The earlier local-only snapshot has SHA-256
`f8886930a4e5455750bdab0c6732c3f29562769d19e162cf2e060df894622c43`.
Both snapshots, the shared working tree, and the pre-relocation Git history
must remain available until the owner confirms the game seed to publish.
This candidate is not a backup: loss of this machine would lose both local
copies, and GitHub settings or conversations cannot be restored from them.

If the shared sandbox changes again, compare its hash with the recorded
snapshot before re-extracting; preserve a new copy rather than overwriting
either existing one. Do not reset or discard the shared `sandbox/src/main.sagan`
edit. Before a real split, document installation, exact package resolution,
CI/platform test commands, design review, release artifacts, rollback,
secrets by name only, and an owner clean-machine drill.
