# CHANGELOG: MCP Stack Evolution

This document tracks the architectural decisions and attempts made to create a stable, secure, and unified MCP stack on macOS (OrbStack).


## 2026-11-12

- Added a Role section and recorded the Herdr agent Liv (Gateway) · MCP nginx proxy stack (pane wT:p1) in AGENTS.md.


## 1. Initial Research

Before finalizing this stack, several community variants were tested and identified as unstable or incompatible with a hardened container environment:

### Context7 Variants Tested

*   `mcp/context7:latest`: Failed due to entrypoint issues.
*   `mekayelanik/context7-mcp:latest`: Failed with permission errors (`su-exec`).
*   **Winner**: `acuvity/mcp-server-context-7:latest` (Official, stable HTTP support).

### SearXNG Variants Tested

*   `overtlids/mcp-searxng-enhanced`: Failed on read-only filesystems.
*   `ghcr.io/mcp-ecosystem/mcp-searxng`: Access denied (Private).
*   **Winner**: `isokoliuk/mcp-searxng:latest` (Unique HTTP transport mode).

---

## 2. Technical Journey

### Attempt 1: Official Docker MCP Gateway (Static Mode)

*   **Method**: `docker/mcp-gateway` with `--static` and `--servers=name=url`.
*   **Result**: **Failed.**
*   **Issue**: The gateway reported "0 tools listed" in microseconds. It failed to perform the necessary SSE handshake with the sub-servers, leading to session errors in SearXNG.

### Attempt 2: Docker MCP Gateway (Managed Mode)

*   **Method**: Mounting `/var/run/docker.sock` to let the Gateway manage containers.
*   **Result**: **Abandoned by user request.**
*   **Issue**: While this is the "intended" way for the gateway to work, the user explicitly requested a more secure setup that **avoids the Docker socket**.

### Attempt 3: Docker MCP Gateway (Catalog-based)

*   **Method**: Using `--catalog` with various formats (List vs Object).
*   **Result**: **Failed.**
*   **Issue**: The gateway consistently reported "No server enabled." The discovery logic in the Go-based gateway proved inconsistent when proxying to existing HTTP containers.

### Attempt 4: Unified Nginx Proxy (Current Stable Version) ✅

*   **Method**: A lightweight Nginx Alpine container acting as a reverse proxy.
*   **Result**: **Successful.**
*   **Why it works**: 
    *   Correctly handles **Streamable HTTP (SSE)** headers (`proxy_buffering off`, etc.).
    *   Provides stable, named endpoints (`/context7/mcp` and `/searxng/mcp`).
    *   Zero dependency on the Docker socket.
    *   Compatible with Zed's modern MCP implementation.

---

## Final Architecture Summary

*   **Transport**: Streamable HTTP (via Nginx proxy).
*   **Endpoints**:
    *   `http://localhost:${GATEWAY_PORT}/context7/mcp`
    *   `http://localhost:${GATEWAY_PORT}/searxng/mcp`
*   **Security**: No `docker.sock`, `read_only` filesystems, and non-privileged containers.
*   **Stability**: Verified healthy in OrbStack and connected in Zed.

## Why `catalog.yaml` is no longer needed

The `catalog.yaml` file was a specific configuration requirement for the **Docker MCP Gateway** (`docker/mcp-gateway`). Its purpose was to tell that specific Go-based tool which servers to spin up or proxy. 

Since we have moved to a **Standard Nginx Proxy** architecture:
1.  **Direct Definition**: Servers are now defined directly in the standard `docker-compose.yml`.
2.  **Explicit Routing**: The routing logic is handled by `nginx.conf`.
3.  **Transparency**: We no longer have a "black box" (the gateway) trying to parse a proprietary YAML format. This makes the stack more reliable and easier to debug.
