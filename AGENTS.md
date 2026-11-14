Herdr agent: Liv (Gateway) · MCP nginx proxy stack

Lead bot: Liv / Visibility: public / Default branch: main / Push: direct

`CLAUDE.md` is a symlink to `AGENTS.md` (`ln -sf AGENTS.md CLAUDE.md`). Edit `AGENTS.md` only. Do not keep a second copy.

## Role

### Project

This repository is a containerized Model Context Protocol proxy. Nginx routes streamable HTTP to a Context7 server and a SearXNG server. The containers do not mount the Docker socket.

### This agent owns

- `docker-compose.yml`, `nginx.conf.template`, and `.env.example` (setting names only).
- The docs for running this proxy.
- The public repo-standard files in the file map.

### Out of scope & handoff

- Other repositories. Do not edit agent-platform from this tree. Its handoff folder is handled separately.
- The SearXNG base URL and the Context7 API key. They belong in the local env file, never in git.
- Starting, stopping, or reconfiguring containers, hosts, or VMs, unless Axel asks.

## Start here

Read in this order:

1. `AGENTS.md` (this file).
2. `README.md`.
3. `BUGFIXES.md` and `SECURITY.md`.
4. `HANDOFF.md`, the last three entries in `CHANGELOG.md`, and `git log -5`. In this public repo `HANDOFF.md` is gitignored.
5. The current ticket, or else `TODO.md` and `ROADMAP.md`.
6. `docs/README.md`.

## File map

| File | What it is for | Who updates it |
| --- | --- | --- |
| `README.md` | What the repo is, the status line, and where to start | The person who changes the project |
| `AGENTS.md` | Rules for the herdr agent | The owning agent, when the role or the rules change |
| `CLAUDE.md` | Symlink to `AGENTS.md`. Same text. No second copy | Nobody. Recreate it with `ln -sf AGENTS.md CLAUDE.md` |
| `CHANGELOG.md` | What changed, newest first, with a why | Whoever makes the change |
| `ROADMAP.md` | Now, next, later, ideas, and done recently | The owning agent, when the plan moves |
| `TODO.md` | Interim task list until the agent-ops board exists | The agent who holds the work |
| `BUGFIXES.md` | Durable bug writeups, `BF-NNN` | Whoever records the fix |
| `HANDOFF.md` | Done, next, and open questions. Tracked in a private repo. Gitignored in a public repo | The agent, before stopping |
| `SECURITY.md` | Threat model, where secrets live, and leak response | The owning agent, when the threat model changes |
| `LICENSE` | Rights granted for this repo | Axel |
| `justfile` | Repeatable recipes, including the secret check | Whoever adds a recipe |
| `docker-stack.just` | Operator recipes imported by `justfile`. Run only when Axel asks | Whoever adds an operator recipe |
| `docs/` | Longer docs. The index is `docs/README.md` | Whoever writes the doc |
| `docs/README.md` | Index of every docs page | Whoever adds or removes a docs page |
| `docs/proxy.md` | What the Nginx proxy service does | Whoever changes the proxy |
| `docs/context7.md` | What the Context7 service does | Whoever changes that service |
| `docs/searxng.md` | What the SearXNG MCP service does | Whoever changes that service |
| `.env.example` | Setting names only. No secret values | Whoever adds a setting |
| `.githooks` | Git hooks. `pre-commit` runs the secret check | Whoever changes the check |
| `.githooks/pre-commit` | Runs `scripts/check-secrets.sh --staged` | Whoever changes the check |
| `scripts/check-secrets.sh` | Fails when a secret-shaped file name or a gitleaks finding is in scope | Whoever changes the check |
| `scripts/lint.sh` | Shellcheck the scripts and hooks, then reject whitespace errors | Whoever changes the check |
| `scripts/docs-index.sh` | Refresh the generated list in `docs/README.md` | Whoever changes the index |
| `scripts/repo-audit.sh` | Report standard files that are missing | Whoever changes the standard |
| `.gitleaks.toml` | Gitleaks rules and the license-text allowlist | Whoever changes the secret check |
| `.github/workflows/gitleaks.yml` | Gitleaks on push and pull_request | Whoever changes the CI check |
| `.gitignore` | Ignore rules. Public fragment keeps the handoff and the private changelog untracked | Whoever changes ignore rules |
| `docker-compose.yml` | Service definitions. Ports and secrets come from the environment | Whoever changes the stack |
| `nginx.conf.template` | Proxy routes. The named env vars are substituted at container start | Whoever changes routing |

## Hard limits

- Secrets never go into git. No tokens, auth keys, `.env` files other than `.env.example`, `auth.json`, credential files, private keys, or session exports. Use a placeholder such as `<SECRET>`.
- This repository is public. Never add IP addresses, hostnames, MAC addresses, internal paths, usernames, email addresses, vault IDs, credentials, or pane IDs.
- Do not open or copy a real `.env`. `.env.example` holds names and empty placeholders only.
- Do not mount the Docker socket.
- Operator recipes (`up`, `down`, `restart`, `logs`, `ps`, `pull`, `config`) run only when Axel asks. Do not run them as part of a docs-only change.
- Do not edit agent-platform. Do not commit `HANDOFF.md` or `CHANGELOG.private.md`.
- Mark anything you have not verified as **unverified**.

## Workflow

- Work through tickets and pull requests when the agent-ops board exists. Until then, track the task in `TODO.md`.
- One ticket at a time. Write a holder line on the ticket before you start, so two agents do not take the same ticket.
- Push for this repo is direct: after the secret check, push to the existing remote on `main`.
- Stage by explicit path. Do not use `git add -A` or `git add .`.
- No force-push. A history rewrite needs Axel's approval.
- If a permission question or a blocker cannot be resolved, stop and say so.

## Documentation, commit & push

Standing rule from Axel (2026-11-12), for every Grok bot and herdr agent working in this repo:

- Document every change in this project: README, `docs/`, and the changelog (`CHANGELOG.md` or `docs/changelog.md`), with date and what/why.
- Commit with a clear message, then push to the repo's existing remote, public or private, after the secret check.
- Before each commit, run a secret check: `git diff --cached --name-only` and `git diff --cached`. Never commit `.env*`, keys, tokens, `auth.json`, credentials, session exports, or `*.bak*` files. If one is staged, unstage it and add it to `.gitignore`.
- Public repos (`gh repo view --json visibility`): be extra strict. Before pushing, review the full diff being pushed (`git diff @{u}..HEAD`) for secrets, tokens, private IPs and hostnames the repo does not already contain, personal data, and session exports. If anything looks sensitive, do not push; report it to Axel.
- If the repo has no remote, commit locally and report that.
- Commit only your own change; do not sweep in someone else's uncommitted work.

Confirmed by Axel (2026-11-14) for every Grok Bot and Herdr agent:

- Document each change in this repo's own files (README, `docs/`, changelog). A memory note, chat message, or handoff outside the repo does not count.
- Then commit and push to the existing remote after the secret check. Stage by explicit path only (no `git add -A` or `git add .`).
- Force-pushes and history rewrites need Axel's explicit approval.

## Secrets

Secrets live in Proton Pass, in `~/.grok/.env`, or on Axel's secure secret cards. They do not live in this repository.

Before every commit, run:

```
git diff --cached --name-only
git diff --cached
scripts/check-secrets.sh --staged
```

The `pre-commit` hook runs `scripts/check-secrets.sh --staged` after `just setup`.

If a secret was committed: rotate it first, tell Axel, and do not rewrite history unless Axel approves the force-push.

## Handoff

Before you stop, write what you did, what is next, and the open questions.

In a private repository, update `HANDOFF.md` and keep it tracked.

In a public repository, `HANDOFF.md` is gitignored. Write the note in the agent-platform repository at `handoffs/<repo>.md`.

## Work tracking

Rule from the owner (2026-11-13): all open work goes on the owner's private GitHub Project board, not into new TODO.md items or chat-only lists.

1. File an issue in this repo (or a draft item on the board if no repo fits) and add it to the board with `gh project item-add` (find the board with `gh project list --owner @me`).
2. Link each pull request to its issue (`Closes #<n>` in the PR body) and add the PR to the board too.
3. Set **Status** (Inbox / Waiting on Axel / In progress / Done) and **Owner** (your agent or bot name; if your name is not an Owner option yet, pick your lead bot and write your name in the item).
4. Anything that needs the owner gets Status "Waiting on Axel" and the `waiting-on-axel` label. Ping the owner only if it is urgent; the morning digest covers the rest.
5. Use `gh` on the owner's machine (it has the `project` scope). The GitHub connector cannot reach personal Projects.
6. Existing TODO.md files stay for now; do not add new items to them.
