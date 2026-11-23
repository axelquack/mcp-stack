# Proxy

Nginx (`nginx:1.31.9-alpine@sha256:fb4658584bd9a916ffb6f6e365f97c25cfdb2923801f551ea08356e695f14ff7`) is the client entry. The digest is the multi-arch index. To bump it, replace the tag and the digest together in `docker-compose.yml`. Renovate, Dependabot, or a manual edit does that. It listens on `PROXY_INTERNAL_PORT` and is published as `BIND_ADDRESS`:`GATEWAY_PORT`.

`nginx.conf.template` routes `/context7/` and `/searxng/` to the matching upstream and strips that prefix. Buffering is off, the proxy HTTP version is 1.1, and the read timeout is 300 seconds, so a streamable HTTP response can stay open.

The template reads `INTERNAL_PORT` and `PROXY_INTERNAL_PORT` from the environment when the container starts. Names are listed in `.env.example`.

The proxy starts after the Context7 and SearXNG healthchecks pass. It does not mount the Docker socket. It does not use the read-only root, capability drop, or no-new-privileges settings that the two MCP containers use.
