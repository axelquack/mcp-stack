# Unified MCP Stack (OrbStack Optimized)

Status (2026-11-12, Europe/Berlin): `CHANGELOG.md` is newest-first. A pane ID was removed from the Herdr agent line and from the changelog.

This project provides a fully containerized, secure, and unified Model Context Protocol (MCP) stack using **Nginx as a high-performance proxy**. It is specifically optimized to run on **macOS Apple Silicon** using **OrbStack**, avoiding common issues with Docker socket dependencies.

## Architecture

The stack consists of three primary services running in isolated Docker containers:

1.  **Unified Nginx Proxy**: Acts as a central gateway. It routes traffic based on the URL path.
2.  **Context7 MCP Server**: Provides documentation and code context.
3.  **SearXNG MCP Server**: Provides web search capabilities.

## Key Features

*   **Zero Port Exposure**: All port numbers are abstracted into the `.env` file for maximum security and flexibility.
*   **Dynamic Configuration**: Uses `nginx.conf.template` to automatically inject environment variables at startup.
*   **Zero Docker Socket Dependency**: The proxy does not require `/var/run/docker.sock`, significantly improving security.
*   **Unified Access**: Both MCP servers are aggregated behind a single entry point.
*   **Hardened Security**:
    *   Containers run with `read_only: true` filesystems.
    *   Capabilities are dropped (`cap_drop: ALL`).
    *   No privilege escalation allowed (`no-new-privileges: true`).
    *   Internal servers are not exposed to the host/internet; only the Proxy is reachable.

## Getting Started

### Prerequisites
*   [OrbStack](https://orbstack.dev/) (or Docker Desktop)
*   An Olares instance for SearXNG (configured in `.env`)

### Installation

1.  **Start the stack:**
    ```bash
    docker-compose up -d
    ```

2.  **Verify the services:**
    ```bash
    docker-compose ps
    ```

## Connecting to Clients

### Zed
Zed is already configured to use the following endpoints:

*   **Context7**: `http://localhost:${GATEWAY_PORT}/context7/mcp`
*   **SearXNG**: `http://localhost:${GATEWAY_PORT}/searxng/mcp`

You can verify these settings in your Zed `settings.json` file (`cmd+,`).

## Configuration Files

*   **`docker-compose.yml`**: The main orchestration file. Uses environment variables for all network settings.
*   **`nginx.conf.template`**: The routing template that dynamically configures the proxy.
*   **`.env`**: **The only place** where secrets, URLs, and port numbers are stored.

## Troubleshooting

*   **Port Busy**: If the `${GATEWAY_PORT}` is already in use, simply change it in the `.env` file and restart.
*   **Configuration Sync**: If you change ports in `.env`, run `docker-compose up -d` to regenerate the proxy configuration.
