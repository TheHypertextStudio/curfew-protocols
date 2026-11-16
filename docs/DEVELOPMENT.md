# Development

## Quickstart

Build and test a fresh clone with public tools only. The committed `.npmrc` routes only the `@thehypertextstudio` scope to GitHub Packages, and nothing this repository installs comes from that scope, so `pnpm install` reads only the public npm registry.

Install these first:

- Node.js 20 or newer (CI runs 22 and 24) and pnpm 10.33.0, which `package.json` pins in `packageManager`.
- JDK 21. The Kotlin module targets JVM 17 and downloads its own Gradle 9 through `./gradlew`.
- Swift 6 with Xcode on macOS, for the generated Swift package.

Then run, from the repository root:

```sh
pnpm install --frozen-lockfile
pnpm typecheck
pnpm typecheck:consumer
pnpm test
swift test
pnpm test:kotlin
```

`pnpm test` checks the schemas and that the generated code is deterministic. `swift test` and `pnpm test:kotlin` run the generated Swift and Kotlin decoder tests against the shared golden vectors in `tests/vectors/`.

After changing a schema, run `pnpm codegen` and commit the regenerated files under `generated/`. Every schema change also needs a version bump and a changelog entry, as described in [`AGENTS.md`](../AGENTS.md).
