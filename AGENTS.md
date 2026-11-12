# Agent conventions — mcp-stack

## Role

- **Project:** Containerized Model Context Protocol stack for macOS/OrbStack: Nginx as a unified proxy in front of a Context7 MCP server and a SearXNG MCP server.
- **This agent owns:** `docker-compose.yml`, `nginx.conf.template`, and the docs for running this proxy stack.
- **Out of scope / handoff:** Unclear whether this agent also maintains sibling repos `mcp-mate` or `open-code` (the herdr `~mcp-stack` space lists them; this tree does not). The SearXNG backend is an Olares instance configured in `.env`, not in this repo. Do not commit `.env` or expose internal ports.

Herdr agent: Liv (Gateway) · MCP nginx proxy stack (pane wT:p1)

## Documentation, commit & push

Standing rule from Axel (2026-11-12), for every Grok bot and herdr agent working in this repo:

- Document every change in this project: README, `docs/`, and the changelog (`CHANGELOG.md` or `docs/changelog.md`), with date and what/why.
- Commit with a clear message, then push to the repo's existing remote, public or private, after the secret check.
- Before each commit, run a secret check: `git diff --cached --name-only` and `git diff --cached`. Never commit `.env*`, keys, tokens, `auth.json`, credentials, session exports, or `*.bak*` files. If one is staged, unstage it and add it to `.gitignore`.
- Public repos (`gh repo view --json visibility`): be extra strict. Before pushing, review the full diff being pushed (`git diff @{u}..HEAD`) for secrets, tokens, private IPs and hostnames the repo does not already contain, personal data, and session exports. If anything looks sensitive, do not push; report it to Axel.
- If the repo has no remote, commit locally and report that.
- Commit only your own change; do not sweep in someone else's uncommitted work.
