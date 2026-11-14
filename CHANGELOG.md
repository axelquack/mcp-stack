# Changelog

This file is published with a public repository.

It must never contain IP addresses, hostnames, MAC addresses, internal paths, usernames, email addresses, vault IDs, credentials, or pane IDs.

Detailed private notes may go into `CHANGELOG.private.md`. That file is gitignored in a public repository. Do not commit it.

Newest first. Dates are Europe/Berlin, `YYYY-MM-DD`.

Use one heading per change: `## YYYY-MM-DD — title`. Under it, keep only the subsections that have items. End with a Why line.

## 2026-11-14 — Documentation rule

### Changed

- AGENTS.md: the Documentation, commit & push section now says changes are documented in this repo's own files (not memory notes or chat), staged by explicit path, and that force-pushes need Axel.

**Why:** standing rule from Axel (2026-11-14) for every Grok Bot and Herdr agent.

## 2026-11-13 — Work tracking rule

### Changed

- AGENTS.md has a Work tracking section: open work goes on the owner's GitHub Project board, not into new TODO.md items.

**Why:** one board for all open work (Axel, 2026-11-13).

## 2026-11-12 — Public repo standard

### Added

- The repo-standard file set: `AGENTS.md` skeleton, `CLAUDE.md` symlink, `ROADMAP.md`, `TODO.md`, `BUGFIXES.md`, `SECURITY.md`, `justfile`, `docker-stack.just`, `.githooks/pre-commit`, `scripts/check-secrets.sh`, `scripts/lint.sh`, `scripts/docs-index.sh`, `scripts/repo-audit.sh`, `.gitleaks.toml`, `.github/workflows/gitleaks.yml`, and `.env.example` (names only).
- `docs/README.md` and one page per service (`docs/proxy.md`, `docs/context7.md`, `docs/searxng.md`).
- Public gitignore rules so `HANDOFF.md` and `CHANGELOG.private.md` stay untracked.

### Changed

- `LICENSE` is PolyForm Noncommercial 1.0.0. Versions published before this commit remain available under Apache-2.0.
- `README.md` follows the repo-standard layout and drops the claim that only the proxy is published on the host.
- `AGENTS.md` follows the skeleton. The Herdr agent line is Liv (Gateway) · MCP nginx proxy stack.
- Reviewed `docker-compose.yml` and `nginx.conf.template`. Addresses and ports already come from the environment, so those files were left as they are. The container loopback name in the healthchecks is not a private address.

### Security

- `pre-commit` runs `scripts/check-secrets.sh --staged` after `just setup`.
- GitHub Actions runs gitleaks on push and pull_request.

**Why:** This public repository needs an explicit license, a secret check, and a file map before further edits.

## 2026-11-12 — Sanitize the public changelog

### Changed

- Rebuilt this file in the public changelog layout, newest first.
- Removed a pane ID from the Herdr agent line in `AGENTS.md` and from this file.
- Noted that change in `README.md`.

**Why:** This repository is public. A pane ID does not belong in it.

## 2026-11-12 — Record the Herdr agent

### Added

- A Role section in `AGENTS.md`.
- The Herdr agent line: Liv (Gateway) · MCP nginx proxy stack.

**Why:** Name the agent that owns this proxy stack.

## 2026-04-03 — Nginx proxy replaces the Docker MCP Gateway

### Added

- `nginx.conf.template`, with path routing for Context7 and SearXNG and streamable HTTP (buffering off, long read timeout).
- This changelog, as a record of the gateway attempts.

### Changed

- Client entry is the Nginx proxy. Paths are `/context7/mcp` and `/searxng/mcp` on the gateway port from the environment.
- README was tightened.
- Context7 image is `acuvity/mcp-server-context-7`. An earlier Context7 image failed on its entrypoint. Another failed on a read-only filesystem permission error (`su-exec`).
- SearXNG image is `isokoliuk/mcp-searxng`, which speaks HTTP. One SearXNG image failed on a read-only filesystem. Another image was not accessible because its registry listing was private.

### Removed

- `catalog.yaml` and the Docker MCP Gateway.
- Static gateway mode: it reported no tools and did not complete the SSE handshake.
- Managed gateway mode: it needed the Docker socket, which was rejected.
- Catalog gateway mode: it reported that no server was enabled.

### Security

- The proxy does not mount the Docker socket.
- The MCP containers use a read-only root, dropped capabilities, and no privilege escalation.

**Why:** The gateway could not proxy the existing HTTP servers reliably, and a Docker socket mount was out of scope. Nginx makes the routes explicit.

## 2026-04-01 — Initial stack

### Added

- `docker-compose.yml` for the Context7 and SearXNG MCP servers.
- `catalog.yaml` for the Docker MCP Gateway (removed on 2026-04-03).
- README and the Apache-2.0 `LICENSE`.

**Why:** First containerized MCP stack for a local container runtime.
