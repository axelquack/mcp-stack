# Unified MCP Stack (OrbStack Optimized)

This project provides a fully containerized, secure, and unified Model Context Protocol (MCP) stack. It is specifically optimized to run on **macOS Apple Silicon** using **[OrbStack](https://orbstack.dev/)**, avoiding common issues with Docker socket dependencies.

## Architecture

The stack consists of three primary services running in isolated Docker containers:

1.  **Unified MCP Gateway**: Acts as a central proxy on port `GATEWAY_PORT`. It merges tools from multiple MCP servers into a single endpoint for clients like Zed, Cursor, or Claude Desktop.
2.  **Context7 MCP Server**: Provides documentation and code context (HTTP transport).
3.  **SearXNG MCP Server**: Provides web search capabilities via your Olares instance (HTTP transport).

## Key Features

*   **Zero Docker Socket Dependency**: The gateway does not require `/var/run/docker.sock`. This fixes the restart loops common in OrbStack/non-Desktop environments and significantly improves security.
*   **Unified Endpoint**: All MCP servers are aggregated behind a single port (`GATEWAY_PORT`).
*   **Hardened Security**:
    *   Containers run with `read_only: true` filesystems.
    *   Capabilities are dropped (`cap_drop: ALL`).
    *   No privilege escalation allowed (`no-new-privileges: true`).
    *   Internal servers are not exposed to the host/internet; only the Gateway is reachable.

## Implementation Research & Decisions

This stack is the result of testing several MCP server variants. Below is the research that led to the current stable configuration.

### 1. Context7 MCP Servers Tried

| # | Image / Version | Status | Notes / Issue |
|---|---|---|---|
| 1 | `mcp/context7:latest` | Failed / Restarting | Old image, entrypoint issues |
| 2 | `mekayelanik/context7-mcp:latest` | Failed / Restarting | `su-exec: setgroups: Operation not permitted` |
| 3 | `mekayelanik/context7-mcp:stable` | Failed | Tag not found |
| 4 | **`acuvity/mcp-server-context-7:latest`** | **Stable & Working** | **Best Choice**: Official image with native HTTP/SSE (Minibridge) support. |

### 2. SearXNG MCP Servers Tried

| # | Image / Version | Status | Notes / Issue |
|---|---|---|---|
| 1 | `overtlids/mcp-searxng-enhanced:latest` | Failed / Restarting | Read-only filesystem error (`ods_config.json`) |
| 2 | **`isokoliuk/mcp-searxng:latest`** | **Stable & Working** | **Best Choice**: Supports HTTP transport mode via `MCP_HTTP_PORT`, allowing container-to-container communication. |
| 3 | `ghcr.io/mcp-ecosystem/mcp-searxng:latest` | Pull denied | Repository not public |
| 4 | `ghcr.io/nalgeon/mcp-searxng:latest` | Pull denied | Repository not public |

### 3. MCP Gateways Tried

| # | Image / Method | Transport | Status | Main Issue |
|---|---|---|---|---|
| 1 | `docker/mcp-gateway:latest` (official) | streamable-http | Restarting | Tries to connect to Docker daemon socket |
| 2 | `docker/mcp-gateway:latest` + `--static` | streamable-http | Restarting | Daemon socket issue |
| 3 | `docker/mcp-gateway:latest` + `--catalog` | streamable-http | Restarting | Daemon socket issue |
| 4 | **`docker/mcp-gateway:latest` + `DOCKER_MCP_IN_CONTAINER=1`** | **streamable-http** | **Stable** | **Final Fix**: Forces the gateway to act as a proxy without requiring the Docker socket. |

---

## Technical Insights

### Why OrbStack over Colima?

For **Apple Silicon (M1/M2/M3)**, OrbStack is recommended over Colima for several reasons:

*   **Performance**: Native virtualization layer optimized for macOS.
*   **Networking**: Handles local DNS and bridge networking seamlessly, which is critical for container-to-container communication on port INTERNAL_PORT.
*   **Resource Efficiency**: Only uses system resources when containers are active.

### The "Gateway Restart" Mystery

The official `docker/mcp-gateway` is designed to be a "container manager"—it wants to talk to `/var/run/docker.sock` to spin up servers dynamically. Inside a container on macOS, this socket is either unavailable or restricted. 

**The Solution:** By setting `DOCKER_MCP_IN_CONTAINER=1` and using the `--static` flag with pre-defined `--servers`, we tell the gateway: *"Don't try to manage Docker. Just be a proxy. I've already started the other containers for you."*

---

## Getting Started

### Prerequisites
*   [OrbStack](https://orbstack.dev/) (or Docker Desktop)
*   An Olares instance for SearXNG (configured in `docker-compose.yml`)

### Installation

1.  **Start the stack:**
    ```bash
    docker-compose up -d
    ```

2.  **Verify the services:**
    ```bash
    docker-compose ps
    ```

3.  **Check the logs:**
    ```bash
    docker-compose logs -f gateway
    ```

## Connecting to Clients

### Zed
In your Zed settings, add an MCP server with the following configuration:
*   **Type**: `Streamable HTTP` (SSE)
*   **URL**: `http://localhost:GATEWAY_PORT/mcp`

### Other Clients
Any client supporting the MCP **Streamable HTTP** transport can connect to `http://localhost:GATEWAY_PORT/mcp`.

## Configuration Files

*   **`docker-compose.yml`**: The main orchestration file. Contains service definitions, environment variables, and security settings.
*   **`catalog.yaml`**: A reference file documenting the servers and their transport configurations.

## Adding More Servers

To add a new MCP server:

1.  Add the service to `docker-compose.yml`. Ensure it is configured for HTTP transport (e.g., via `PORT` or `MCP_HTTP_PORT`).
2.  Update the `gateway` command in `docker-compose.yml` to include the new server:
    ```yaml
    command:
      - --servers=my-new-server=http://my-new-server:INTERNAL_PORT/mcp
    ```
3.  Restart the stack: `docker-compose up -d`.

## Troubleshooting

*   **Gateway Restarting**: Ensure `DOCKER_MCP_IN_CONTAINER=1` is set in the gateway environment variables.
*   **No Tools Found**: Check the individual server logs (`docker-compose logs context7`) to ensure they are listening on port INTERNAL_PORT and the `/mcp` endpoint is active.
