// AUTO-GENERATED from schemas/*.json by codegen/typescript.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// From mcp-tools.json

/**
 * The Curfew MCP tool registry. Each entry describes one tool exposed by `curfew-mcp` over the Model Context Protocol — its stable name, the human-readable description shown to AI clients in `tools/list`, and the JSON Schema for the `arguments` payload accepted by `tools/call`.
 *
 * This manifest is extracted verbatim from `Sources/curfew-mcp/MCPTool.swift` in the Curfew repo at the same version tag. Adding or modifying a tool requires updating the Swift source first and re-extracting; the schema is the contract, not a separate truth.
 */
export interface MCPToolRegistry {
  tools: MCPToolDefinition[]
}
export interface MCPToolDefinition {
  /**
   * Stable identifier sent in `tools/list` and matched in `tools/call`.
   */
  name: string
  /**
   * Human-readable description shown to the AI model when it enumerates tools.
   */
  description: string
  /**
   * JSON Schema describing the `arguments` payload the tool accepts.
   */
  inputSchema: {}
}

// From pending-request.json

/**
 * A write-tool request queued by `curfew-mcp` for user approval in the Curfew app.
 *
 * Lifecycle:
 * 1. `curfew-mcp` creates a pending request with `status = pending` and appends it to the request queue.
 * 2. The Curfew app's `MCPRequestMonitor` detects the new entry and shows a consent sheet.
 * 3. The user approves or denies. The app updates `status` in-place and sets `resolvedAt`.
 * 4. `curfew-mcp` polls the queue file until the entry's `status` changes from `pending`, then responds to the MCP client accordingly. Timeout after 120 seconds → "timed out" error to the client.
 */
export interface MCPPendingRequest {
  /**
   * Stable unique key for this request. Used by `curfew-mcp` to find its own entry in the queue after a poll cycle.
   */
  id: string
  /**
   * The write tool that was invoked.
   */
  tool: "curfew.request_extension" | "curfew.request_override" | "curfew.set_schedule"
  /**
   * Freeform arguments from the MCP client (tool-specific JSON payload decoded from the `tools/call` params). Stored verbatim so the app can reconstruct the exact user-facing prompt.
   */
  argumentsJSON: string
  /**
   * ISO 8601 timestamp when `curfew-mcp` added the request.
   */
  requestedAt: string
  /**
   * Approval state. Starts as `pending`; the app writes `approved` or `denied` after user interaction.
   */
  status: "pending" | "approved" | "denied"
  /**
   * Set by the app when the user resolves the request.
   */
  resolvedAt?: string | null
  /**
   * Human-readable note the app may attach on denial (e.g. "Not during lockout"). Null on approval and on pending requests.
   */
  denialReason?: string | null
  /**
   * Hex-encoded HMAC-SHA256 produced by `MCPRequestSigner`. Present on requests written by `curfew-mcp`; absent on legacy entries or payloads written by other tools. The app treats absent/invalid signatures as "do not auto-approve" — they still flow to the consent sheet so the user can decide explicitly.
   */
  signature?: string | null
}
