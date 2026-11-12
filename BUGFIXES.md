# Bugfixes

Durable bug writeups. One heading per bug: `BF-NNN`. Keep the number. Do not reuse it.

## BF-001 — Docker MCP Gateway listed no tools

- Status: fixed
- Date: 2026-04-03
- Symptom: The gateway reported that no tools were listed and did not complete the SSE handshake. Catalog mode reported that no server was enabled.
- Cause: The gateway did not proxy the existing HTTP servers reliably. The mode that manages containers needed the Docker socket, which was rejected.
- Policy: Use the Nginx proxy in this repository. Do not mount the Docker socket.
