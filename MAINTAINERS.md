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
`tests/fixtures/outpost_seed/` preserves the numeric prototype seed. The installed-toolchain test and
release pipeline remain unverified. Do not present this source as a game
release.

## Reproduce the current focused check

Independent seed CI checks out exact language, physics, and renderer commits
from the three `sagan-*-commit.txt` files, builds the compiler, emits the
windowed `src/game.sagan` application package, then runs the numeric seed in
`tests/fixtures/outpost_seed/` as a console package on Linux, Windows, and macOS using
`bash tests/integration/game_seed_test.sh`. These source pins
are a temporary CI path while released package
consumption is paused; they do not certify a game release. Keep the lockfile
and package versions compatible when changing any pin.

From the repository root in Bash (Git Bash on Windows), build and run the
windowed game with:

```bash
bash scripts/run.sh
```

To resolve and build all pinned dependencies without compiling or launching
the game, use:

```bash
bash scripts/rebuild.sh
```

To run an individual Sagan file with the current pinned compiler and package
catalog on macOS, Linux, or Windows Bash, use:

```bash
bash scripts/sagan.sh src/resources.sagan
```

The wrapper forwards all arguments to the compiler and resolves the catalog
on each invocation unless `SAGAN_PACKAGE_INDEX` is explicitly set. It reuses
the existing dependency caches and follows the tracked pins when they change.
Clear an old terminal override with `unset SAGAN_PACKAGE_INDEX` to restore
automatic resolution. Relative file arguments use the caller's working directory.

`scripts/run.sh` calls this dependency preparation step before it compiles the
game, then launches the selected entry point unless `--build-only` is set.

On the first run, `scripts/resolve-sagan.sh` clones the exact commit in
`sagan-source-commit.txt`, builds it under ignored
`build/sagan-pinned-<commit>/`, and reuses that compiler on later runs.
Reuse requires both the cached checkout and its successful-build provenance
stamp to match the full pinned commit. A missing or mismatched stamp causes a
clean rebuild, preventing an interrupted update from leaving a stale executable
behind an apparently current source checkout.
`scripts/resolve-physics.sh` likewise clones the exact commit in
`sagan-physics-commit.txt` under ignored
`build/sagan-physics-pinned-<commit>/`. `scripts/resolve-render.sh` clones the
exact `sagan-render-commit.txt` commit under
`build/sagan-render-pinned-<commit>/`; `scripts/resolve-packages.sh` composes
the compiler checkout's `sagan-time` library, physics package, and rendering
package into an ignored relative-path catalog keyed by all three source pins.
The launcher emits and
links one native windowed executable using the renderer's SDL resolver. An
incomplete cache is preserved with an `.incomplete-<timestamp>` suffix rather
than overwritten. The first run requires network access, Git, Make, curl,
unzip, and the compiler prerequisites for Sagan and the renderer. On Windows,
run from an MSYS2 UCRT64 Git Bash environment so the native compiler is
available.

On macOS, install Apple's Command Line Tools with `xcode-select --install`
if `c++`, Git, or Make is missing. The renderer builds its checksum-pinned
SDL3 source and supplies the CMake bootstrap when CMake is absent; Ninja
is optional. Homebrew is not required. The native host uses Metal and the
renderer-owned MSL shader artifacts. The executable embeds the pinned SDL
installation's library search path. Retain that ignored renderer cache while
using the executable. This is a local development build, not a signed or
distributed macOS application.

To build without leaving a window open, use `bash scripts/run.sh --build-only`.
On macOS the launcher stages `build/game/application/Sagan Space Game.app`
with the compiler's canonical Sagan logo in its icon resources. It runs the
executable inside that bundle, retaining the renderer working directory and
environment. The bundle depends on the pinned renderer cache and launcher
shader configuration; use the launcher for development runs.
The executable is `build/game/space-game` on Linux, or
`build/game/space-game.exe` on Windows. The macOS CI job checks the bundle's
property list and canonical icon, runs the numeric seed,
builds the native host, and records the two fixed-camera captures with
`tests/integration/shackleton_view_test.sh`. That fixture requests and verifies
960×540 captures so hosted desktop bounds do not resize the comparison views.
Run graphical checks in a logged-in
desktop session; successful package emission alone does not verify Metal.
If a newly installed full Xcode reports an unaccepted license, complete its
setup yourself. To use the separately installed Command Line Tools for this
development build, run
`DEVELOPER_DIR=/Library/Developer/CommandLineTools bash scripts/run.sh`.

Set `SAGAN_EXECUTABLE`, `SAGAN_PACKAGE_INDEX`,
`SAGAN_PHYSICS_SOURCE_ROOT`, or `SAGAN_RENDER_SOURCE_ROOT` only for an explicit
reviewed override. Every source-root override must match its exact pin.
`SAGAN_BUILD_JOBS` controls compiler build parallelism and defaults to `2`.
A successful `bash scripts/run.sh` opens the separate `src/game.sagan` entry
directly into the fixed local Shackleton Base view and continues until the
window closes. The standalone numeric fixture
still advances fourteen 0.1-second steps, reaches 35 watt-seconds of stored
charge with 86 kilograms each of water, food, and oxygen, then exits zero.
`bash tests/integration/compiler_rollout_test.sh` checks the pinned compiler's
native monotonic time package and the dictionary syntax used by application
code, including static word keys, dot and bracket access, explicit computed
keys, and missing-key failures.
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
