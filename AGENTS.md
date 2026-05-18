# AGENTS.md — curfew-protocols

This repo is the versioned wire-format contract between the Curfew macOS app and the Curfew Sync coordinator. The discipline is narrow because the scope is narrow.

## Repo topology

- **`curfew`** — Swift macOS app, license-issuer Worker, landing. Consumes this package via SPM.
- **`curfew-sync`** — Cloudflare Worker coordinator. Consumes this package via npm.
- **`curfew-protocols`** (this repo) — JSON Schemas + emitted TypeScript and Swift types.

## Non-negotiable rules

1. **JSON Schemas in `schemas/` are the source of truth.** Never hand-edit anything under `generated/`. If a generated file is wrong, fix the schema or the codegen, never the output.
2. **Every schema change is a four-step changeset:**
   - Edit the schema.
   - Run `pnpm codegen` and commit the regenerated `generated/typescript/` and `generated/swift/Sources/CurfewProtocols/` outputs.
   - Run `pnpm test` (contract tests roundtrip every schema through both codegens; failure means the codegens disagree about a field shape).
   - Bump `package.json` version (semver: additive = minor, breaking = major) and add an entry to `CHANGELOG.md`.
   All four happen in the same PR.
3. **Tag and publish in a single step.** After merge to `main`, run `pnpm publish` (the `prepublishOnly` script re-runs codegen + typecheck + test) and `git tag vX.Y.Z && git push --tags`. The tag and the npm version must match.
4. **No business logic in this repo.** No tool implementations, no request handlers — only shapes. If a change feels like adding logic, it belongs in the consumer repo.
5. **Generated outputs are committed.** Consumers (the Swift app, the TS Worker) must be able to depend on this package without running `pnpm codegen` themselves. CI verifies the committed outputs match a fresh regeneration.

## Standard commands

```sh
pnpm install
pnpm codegen     # regenerate TS + Swift outputs
pnpm test        # vitest contract tests
pnpm typecheck   # tsc --noEmit
pnpm publish     # publish to npm (runs prepublishOnly)
```

## Change classification

| Change | Version bump | Required actions |
|---|---|---|
| New tool added to `mcp-tools.json` | Minor | Regen, test, changelog |
| New optional field on existing shape | Minor | Regen, test, changelog |
| New required field on existing shape | Major | Regen, test, changelog + consumer migration notes |
| Field rename / type change | Major | Regen, test, changelog + consumer migration notes |
| Description-only edit | Patch | Regen, test, changelog |

## Verification before completion

- `pnpm codegen` produces zero diff against committed `generated/` (i.e. you remembered to commit the regen).
- `pnpm test` green.
- `pnpm typecheck` clean.
- `CHANGELOG.md` has an entry under the new version.
- `package.json` version bumped.
- Swift consumers (`swift build` against this package's `Package.swift`) succeed.
