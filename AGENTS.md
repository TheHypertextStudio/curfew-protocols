# AGENTS.md — curfew-protocols

This repo is the versioned wire-format contract between the Curfew macOS app and the Curfew Sync coordinator. The discipline is narrow because the scope is narrow.

## Repo topology

- **`curfew`** — Swift macOS app, license-issuer Worker, landing. Consumes this package via SPM.
- **`curfew-sync`** — Cloudflare Worker coordinator. Consumes this package via npm.
- **`curfew-protocols`** (this repo) — JSON Schemas + emitted TypeScript, Swift, and Kotlin/JVM types.

## Non-negotiable rules

1. **JSON Schemas in `schemas/` are the source of truth.** Never hand-edit anything under `generated/`. If a generated file is wrong, fix the schema or the codegen, never the output.
2. **Every schema change is a four-step changeset:**
   - Edit the schema.
   - Run `pnpm codegen` and commit the regenerated TypeScript, Swift, Kotlin, and native golden-test outputs under `generated/`.
   - Run `pnpm test` (contract tests roundtrip every schema through both codegens; failure means the codegens disagree about a field shape).
   - Bump `package.json` version (before 1.0: additive = patch, breaking = minor; at or after 1.0: additive = minor, breaking = major) and add an entry to `CHANGELOG.md`.
   All four happen in the same PR.
3. **Tag and publish in a single step.** After merge to `main`, tag `vX.Y.Z` and push the tag. `.github/workflows/publish-github-package.yml` publishes `@thehypertextstudio/*` to GitHub Packages with the repository `GITHUB_TOKEN`; the tag and package version must match. Local publication uses `pnpm publish` with `NODE_AUTH_TOKEN`, never a committed credential.
4. **No business logic in this repo.** No tool implementations, no request handlers — only shapes. If a change feels like adding logic, it belongs in the consumer repo.
5. **Generated outputs are committed.** Consumers (the Swift app, the TS Worker) must be able to depend on this package without running `pnpm codegen` themselves. CI verifies the committed outputs match a fresh regeneration.

## Standard commands

```sh
pnpm install
pnpm codegen     # regenerate TS + Swift + Kotlin outputs and native golden tests
pnpm test        # vitest contract tests
pnpm typecheck   # tsc --noEmit (skipLibCheck: does not check generated/ .d.ts internals)
pnpm typecheck:consumer  # compiles the emitted .d.ts itself, lib checking on
  pnpm test:kotlin # generated Kotlin/JVM compile and shared-vector tests
  pnpm publish     # publish to GitHub Packages (runs prepublishOnly)
```

## Change classification

| Change | Version bump | Required actions |
|---|---|---|
| New tool added to `mcp-tools.json` | Patch before 1.0, minor after 1.0 | Regen, test, changelog |
| New optional field on existing shape | Patch before 1.0, minor after 1.0 | Regen, test, changelog |
| New required field on existing shape | Minor before 1.0, major after 1.0 | Regen, test, changelog + consumer migration notes |
| Field rename / type change | Minor before 1.0, major after 1.0 | Regen, test, changelog + consumer migration notes |
| Description-only edit | Patch | Regen, test, changelog |

## Commit scopes

- `protocols` — schemas, generated language bindings, release automation, and package documentation.

## Verification before completion

- `pnpm codegen` produces zero diff against committed `generated/` (i.e. you remembered to commit the regen).
- `pnpm test` green.
- `pnpm typecheck` clean.
- `pnpm typecheck:consumer` clean (catches duplicate identifiers and other defects inside the emitted bundle that `pnpm typecheck` skips).
- `CHANGELOG.md` has an entry under the new version.
- `package.json` version bumped.
- Swift consumers (`swift build` against this package's `Package.swift`) succeed.
- Kotlin consumers (`pnpm test:kotlin`) compile and pass the shared vector corpus.
