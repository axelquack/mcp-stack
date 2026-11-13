# mcp-stack

Nginx reverse proxy in front of a Context7 MCP server and a SearXNG MCP server, for a local container runtime. The containers do not mount the Docker socket.

## Status

2026-11-12, Europe/Berlin: public repository on the repo standard. The license is PolyForm Noncommercial 1.0.0. Versions published before this commit remain available under Apache-2.0.

2026-11-13: each container image is pinned to a release tag and its multi-arch index digest.

## Start here

1. `AGENTS.md`
2. This file
3. `BUGFIXES.md` and `SECURITY.md`
4. `HANDOFF.md`, the last three entries in `CHANGELOG.md`, and `git log -5`. `HANDOFF.md` is gitignored in this public repository.
5. The current ticket, or else `TODO.md` and `ROADMAP.md`
6. `docs/README.md`

## Layout

| Path | What |
| --- | --- |
| `AGENTS.md` | Agent rules. `CLAUDE.md` is a symlink to this file. |
| `README.md` | This page. |
| `CHANGELOG.md` | What changed, newest first. |
| `ROADMAP.md` | Now, next, later, ideas, done recently. |
| `TODO.md` | Interim tasks until the agent-ops board exists. |
| `BUGFIXES.md` | Durable bug writeups (`BF-NNN`). |
| `HANDOFF.md` | Done, next, open questions. Tracked in a private repo. Gitignored in a public repo. |
| `SECURITY.md` | Threat model and where secrets live. |
| `LICENSE` | Rights for this repo. |
| `justfile` | Recipes. `just` lists them. `just setup` installs the git hook. |
| `docker-stack.just` | Operator recipes. Run them only when asked. |
| `docs/` | Longer docs. Index: `docs/README.md`. |
| `.env.example` | Setting names only. |
| `.githooks/` | `pre-commit` runs the secret check. |
| `scripts/check-secrets.sh` | Secret check for the working tree, the index, or history. |
| `docker-compose.yml` | The three services. Ports and secrets come from the environment. |
| `nginx.conf.template` | Path routing for the proxy. |

## What it runs

Three services on one private bridge network:

1. **Proxy.** Nginx `nginx:1.31.8-alpine@sha256:713fc2ebfd92e8217db451477182ee91944b123d2b1ee9fd5a8c6e91ca6c3a11`. Client paths are `/context7/mcp` and `/searxng/mcp` on the gateway port. The prefix is stripped before the request reaches the upstream.
2. **Context7.** Documentation and code context. Image `acuvity/mcp-server-context-7:2.1.0@sha256:7d63d51088f7b59046a31bd9056e01bbad51130d8aa3389e56ca52e25cf89d0b`.
3. **SearXNG.** Web search through `isokoliuk/mcp-searxng:2.10.1@sha256:39176ff787129814aa7fbc96250e35b01ccc1bb6586d98ad3963551ba53e405d`. The upstream SearXNG base URL is `SEARXNG_URL` in the local env file.

A bump replaces the tag and the digest together in `docker-compose.yml`. Renovate, Dependabot, or a manual edit does that. The digest is the multi-arch index of that tag.

The proxy is the client entry. The compose file also publishes host ports for the Context7 and SearXNG containers. Those port numbers come from the environment.

The MCP containers use a read-only root, dropped capabilities, and no privilege escalation. The proxy image does not use that same hardening. **Unverified** in this change: the running containers were not inspected.

## Configuration

`.env.example` lists every variable `docker-compose.yml` and `nginx.conf.template` read. Values stay empty there. Copy it to `.env` locally and fill it in. Do not commit `.env`.

`just` lists the recipes. `just setup` points this clone at `.githooks`. The operator recipes in `docker-stack.just` (`up`, `down`, `restart`, `logs`, `ps`, `pull`, `config`) run only when Axel asks.

A local container runtime such as OrbStack or Docker Desktop is required. The SearXNG upstream is configured only through `SEARXNG_URL`.

## License

PolyForm Noncommercial 1.0.0. See `LICENSE`.

Versions published before this commit remain available under Apache-2.0.
