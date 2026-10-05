---
title: Space Game technology overview
status: review-needed
publication_ready: false
verified_in: null
verified_on: null
verified_by: null
---

# Space Game technology overview

This repository owns the game design and application code. The authoritative
goals are in `SPACE_GAME_DESIGN.md`, supplemented only by the owner's later
answers to clarifying questions. Do not infer game requirements from old
Codex chats or treat the current prototype's implementation details as
settled design choices.

The Sagan project manifest `sagan.toml` points to `src/main.sagan` and names
the `sagan-physics` package as a dependency. `sagan.lock` records the currently
selected package version. The game is a consumer: physics algorithms belong
in `sagan-physics`, graphical backends in `sagan-render`, and language/compiler
behavior in `sagan`. The game may use those APIs but must not copy their
implementations into its own source. The future `sagan-workspace` exact lock
will coordinate compatible checkouts for holistic development.

The present Sagan source defines natural-body and spacecraft concepts and
prints sample body summaries and distances. It has no persistent game state,
resource economy, simulation loop, input system, or rendering window yet.
The `Sandbox` package name is inherited from the prototype and is not a
decision about the final product name. The sample's orbital quantities and
outputs should be evaluated as prototype behavior, not as validated
astronomical data or promised gameplay.

The current Windows rehearsal ran the imported source with the existing
Sagan executable and MinGW toolchain and exited successfully. An installed
standalone Sagan distribution plus independently published physics package
has not yet been validated. See [MAINTAINERS.md](MAINTAINERS.md) for the
exact test and recovery path.
