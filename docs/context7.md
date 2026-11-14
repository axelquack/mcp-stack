# Context7

Image: `acuvity/mcp-server-context-7:2.1.0@sha256:7d63d51088f7b59046a31bd9056e01bbad51130d8aa3389e56ca52e25cf89d0b`. The digest is the multi-arch index. To bump it, replace the tag and the digest together in `docker-compose.yml`. Renovate, Dependabot, or a manual edit does that.

The process listens on `INTERNAL_PORT` (`PORT` in the container environment). The host port is `CONTEXT7_EXT_PORT`. The healthcheck calls `CONTEXT7_HEALTH_PORT` inside the container. The compose file passes `CONTEXT7_API_KEY`. The real value belongs only in the local env file.

The container has a read-only root, a noexec temporary filesystem, all capabilities dropped, no new privileges, and a 1g memory limit.

Clients that use the proxy call `/context7/mcp` on the gateway port. That path is forwarded to `/mcp` on this service.
