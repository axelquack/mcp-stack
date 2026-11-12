# Proxy

Nginx (`nginx:alpine`) is the client entry. It listens on `PROXY_INTERNAL_PORT` and is published as `BIND_ADDRESS`:`GATEWAY_PORT`.

`nginx.conf.template` routes `/context7/` and `/searxng/` to the matching upstream and strips that prefix. Buffering is off, the proxy HTTP version is 1.1, and the read timeout is 300 seconds, so a streamable HTTP response can stay open.

The template reads `INTERNAL_PORT` and `PROXY_INTERNAL_PORT` from the environment when the container starts. Names are listed in `.env.example`.

The proxy starts after the Context7 and SearXNG healthchecks pass. It does not mount the Docker socket. It does not use the read-only root, capability drop, or no-new-privileges settings that the two MCP containers use.
