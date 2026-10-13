import { describe, expect, it } from "vitest"
import { validator } from "./schema-validator"

describe("deployment-independent endpoints", () => {
  it("accepts two deployments without changing scopes or schema", async () => {
    const validate = await validator("oauth.json")
    for (const origin of ["https://sync.thecurfew.app", "https://sync.example.net"]) {
      expect(validate({ resource: `${origin}/mcp`, firstPartyResource: origin,
        scopes: ["curfew:devices:read"], firstPartyScopes: ["curfew:sync:read"] }), JSON.stringify(validate.errors)).toBe(true)
    }
  })
  it("rejects insecure resources and credential-bearing URLs", async () => {
    const validate = await validator("oauth.json")
    for (const resource of ["http://sync.example.net/mcp", "https://user:secret@sync.example.net/mcp", "https://sync.example.net/mcp?token=secret", "https://sync.example.net/mcp#fragment"]) {
      expect(validate({ resource, firstPartyResource: "https://sync.example.net", scopes: [], firstPartyScopes: [] })).toBe(false)
    }
  })
  it("allows origin-only MCP security policies for either deployment", async () => {
    const validate = await validator("mcp-app.json")
    for (const origin of ["https://sync.thecurfew.app", "https://sync.example.net"]) {
      const resource = { uri: "ui://curfew/status-and-devices", mimeType: "text/html;profile=mcp-app", text: "<main>Curfew</main>", _meta: { ui: { csp: { connectDomains: [origin], resourceDomains: [origin] } } } }
      expect(validate(resource), JSON.stringify(validate.errors)).toBe(true)
      resource._meta.ui.csp.connectDomains = [origin + "/untrusted"]
      expect(validate(resource)).toBe(false)
    }
  })
})
