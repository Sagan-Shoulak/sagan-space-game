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

The Sagan project manifest `sagan.toml` points to the windowed
`src/game.sagan` entry and names the physics and rendering packages as
dependencies. `sagan.lock` records the currently selected package versions.
The game is a consumer: physics algorithms belong
in `sagan-physics`, graphical backends in `sagan-render`, and language/compiler
behavior in `sagan`. The game may use those APIs but must not copy their
implementations into its own source. The future `sagan-workspace` exact lock
will coordinate compatible checkouts for holistic development.

The windowed game entry opens a first local Shackleton Base presentation using
the exact pinned `sagan-render` package and its native GPU host. It starts in a
fixed oblique camera over the renderer demo's local tangent-patch primitives,
with no orbital view, orbit input, or zoom input. A sidebar presents the small
outpost seed's live charge, water, food, oxygen, and durability values. This is
still a session-only vertical slice: it has no persistence, menus, construction
controls, or authoritative lunar terrain model.
The `Sandbox` package name is inherited from the prototype and is not a
decision about the final product name. The sample's orbital quantities and
outputs should be evaluated as prototype behavior, not as validated
astronomical data or promised gameplay.

The local launcher resolves exact Sagan, physics, and renderer commits into
ignored caches, creates one package catalog, emits the application C++, links
the renderer's native host against pinned SDL, and runs from the renderer root
so its reviewed shaders and planetary assets remain available. These exact
source pins are development integration inputs, not released-package evidence.
On macOS the host uses SDL's Metal backend and renderer-owned MSL shaders.
The launcher builds the renderer's pinned SDL source and embeds its library
search path in the native executable. `scripts/run.sh --build-only` builds
without opening a window; the graphical integration check then captures the
fixed local scene and verifies that camera input leaves it unchanged.
See [MAINTAINERS.md](MAINTAINERS.md) for the exact test and recovery path.
