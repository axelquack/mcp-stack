# SearXNG

Image: `isokoliuk/mcp-searxng:2.10.1@sha256:39176ff787129814aa7fbc96250e35b01ccc1bb6586d98ad3963551ba53e405d`. The digest is the multi-arch index. To bump it, replace the tag and the digest together in `docker-compose.yml`. Renovate, Dependabot, or a manual edit does that.

The process listens on `INTERNAL_PORT` (`MCP_HTTP_PORT` in the container environment). The host port is `SEARXNG_EXT_PORT`. The healthcheck calls `/health` on that same internal port. `SEARXNG_URL` is the base URL of the upstream SearXNG instance and belongs only in the local env file.

The container timezone is set to `Europe/Berlin` in the compose file. The container has a read-only root, a noexec temporary filesystem, all capabilities dropped, no new privileges, and a 512m memory limit.

Clients that use the proxy call `/searxng/mcp` on the gateway port. That path is forwarded to `/mcp` on this service.
