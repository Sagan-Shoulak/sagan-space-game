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

Independent seed CI checks out exact language and physics commits from
`sagan-source-commit.txt` and `sagan-physics-commit.txt`, builds the compiler,
then runs `src/main.sagan` against the pinned physics package on Linux and
Windows using `bash tests/integration/game_seed_test.sh`. These source pins
are a temporary CI path while released package
consumption is paused; they do not certify a game release. Keep the lockfile
and package versions compatible when changing either pin.

Install or build Sagan and make a compatible `sagan-physics` package available.
On the current Windows development machine, from this candidate's root in
Git Bash, the verified rehearsal command was:

```bash
PATH=/c/msys64/ucrt64/bin:$PATH /c/Users/joeps/coding/sagan/bin/sagan.exe src/main.sagan
```

It printed Sol, Earth, Luna, Pluto, Ceres, and Halley's Comet summaries and
distances, then exited zero. Invoking the executable without the MinGW
compiler on PATH instead failed to start its native process (Windows error
2); that was an environment failure, not a Sagan diagnostic. On a system with
a properly installed Sagan CLI and physics package, the intended command is
`sagan src/main.sagan`; it still needs independent cross-platform validation.
The manifest currently names the package `Sandbox`, retained from the seed;
rename it only after the owner chooses the game's package identity.

`sagan.toml` declares the physics dependency, and `sagan.lock` selects its
current version. Do not silently replace a released package with a sibling
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
