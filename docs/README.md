# Docs

Docker stack. One page per service. Compose files stay at the repository root. The just recipes `up`, `down`, `restart`, `logs`, `ps`, `pull`, and `config` live in `just/docker-stack.just`. They are the operator interface. Run them only when Axel asks.

Each service page names the pinned image. A bump replaces the release tag and the multi-arch index digest together in `docker-compose.yml`. Renovate, Dependabot, or a manual edit does that.

The license is PolyForm Noncommercial 1.0.0 (`LICENSE`). Versions published before the 2026-11-12 license change remain available under Apache-2.0. What changed, and why, is in `CHANGELOG.md`.

## Services

<!-- docs-index:start -->
- [context7](context7.md)
- [proxy](proxy.md)
- [searxng](searxng.md)
<!-- docs-index:end -->
