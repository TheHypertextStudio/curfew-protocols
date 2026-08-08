# Decision record: the force-moved `v0.1.0` tag

**Status:** open — needs Willie's decision. Nothing in this document has been executed.
**Written:** 2026-08-08.
**Scope:** this is a decision record only. No tag was created, moved, deleted, or pushed while writing it.

## What is broken

`v0.1.0` was force-moved. It no longer points at the commit consumers pinned.

| | Commit | Date | Subject |
|---|---|---|---|
| **What `v0.1.0` points at now** | `c6f12a79d7daadcae39e9956d022cbace0619ae4` | 2026-07-31 | `chore(protocols): adopt MIT license` |
| **What consumers recorded** | `1d482817025734d8ede3d2eaf9575b62cc981bc3` | 2026-05-18 | `fix(codegen): rename MCPWriteTool enum cases to match existing Swift API` |

`v0.1.0` is an annotated tag, object `605274eec9126a7fc0b6678b922b66f1544067f8`, tagged **2026-07-31T10:53:59-07:00**. The original 0.1.0 release commit is `88704ff3ca8d59c8cc356c87fb519dd070628984` (2026-05-18), and `CHANGELOG.md` dates `[0.1.0]` to 2026-05-18. So the tag object was written roughly ten weeks after the release it names — it is a re-cut, not the original.

Reproduce the state:

```sh
git cat-file -p v0.1.0          # object c6f12a79…, tagger date 2026-07-31
git rev-parse v0.1.0^{commit}   # c6f12a79d7daadcae39e9956d022cbace0619ae4
```

## Why that breaks the build

SwiftPM applies trust-on-first-use to source-control dependencies. The first time a machine resolves `curfew-protocols` at version `0.1.0`, it records the resolved revision as a fingerprint. On every later resolution it re-checks the tag against that record. A version tag is treated as immutable; a tag that resolves to a different commit than the recorded one is, to SwiftPM, indistinguishable from a supply-chain substitution, so it refuses rather than silently accepting the new content.

The fingerprint store on this machine is:

```
~/Library/org.swift.swiftpm/security/fingerprints/
```

(on Linux and older toolchains, `~/.swiftpm/security/fingerprints/`).

The failure is a fingerprint mismatch naming both revisions — the one it just resolved and the one previously recorded — in the form:

```
error: Revision c6f12a79d7daadcae39e9956d022cbace0619ae4 for
  curfew-protocols version 0.1.0 does not match previously recorded value
  1d482817025734d8ede3d2eaf9575b62cc981bc3
```

**Verbatim-text caveat:** the wording above is reconstructed from SwiftPM's fingerprint-mismatch path, not copied from a build log. I could not capture the exact string in this worktree — reading the toolchain binary and the fingerprint store is outside the sandbox, and the Context7 documentation lookup returned `Monthly quota exceeded` (a free API key at https://context7.com/dashboard, or `CONTEXT7_API_KEY`, would lift that). Before quoting this in a consumer-facing note, paste the real line from the failing `curfew` build log. The two SHAs and the store path above are verified facts; only the sentence wrapping them is reconstructed.

## Who is affected

- **`curfew`** (Swift macOS app) — the only consumer at risk. It depends on this package through SwiftPM, so it is the consumer that holds a `Package.resolved` pin and a TOFU fingerprint for `0.1.0`.
- **`curfew-sync`** (Cloudflare Worker) — not affected by the tag. It consumes the package through npm, which resolves by published version, not by git tag.
- **Any CI runner or developer machine that resolved `0.1.0` before 2026-07-31** holds the old fingerprint. A runner with a cold cache resolves the new commit cleanly and records `c6f12a79…` — which is why this failure looks intermittent and machine-dependent. It is not; it is a function of who resolved first.

## Option A — cut a new version tag (recommended)

Leave `v0.1.0` exactly where it is. Cut a new tag at the intended commit and migrate consumers to it.

- `v0.1.0` keeps resolving to `c6f12a79…` forever, so no already-recorded fingerprint is ever contradicted.
- The migration is a one-line change in each consumer's `Package.swift` plus a `swift package update`. It is visible, reviewable, and revertible.
- Machines that never pinned `0.1.0` are unaffected.
- Cost: consumers must act. Until each one bumps, they stay on whatever `0.1.0` resolves to for them.
- Note the version numbering is already ahead of the tags: `package.json` and `CHANGELOG.md` are at `1.0.0`, and `README.md` documents `.package(url: …, exact: "1.0.0")`, but no `v1.0.0` tag exists (`git tag -l` lists only `v0.1.0`). The clean move is to cut `v1.0.0` at the commit that actually matches the 1.0.0 contract and point consumers there, retiring `0.1.0` rather than repairing it.

## Option B — re-cut `v0.1.0` at `1d482817…` (destructive, not recommended)

Force-move the tag back to the commit consumers recorded.

- Appears to "fix" the machines that hold the `1d482817…` fingerprint.
- **Breaks every machine that resolved `0.1.0` after 2026-07-31.** Those recorded `c6f12a79…`; moving the tag back gives them the identical mismatch error, with the SHAs swapped. It relocates the breakage, it does not remove it.
- It is a second force-move. Each one makes the tag less trustworthy as a version identifier and trains consumers to clear their fingerprint store, which is exactly the reflex TOFU exists to prevent.
- Recovery requires every affected person to delete their fingerprint entry and their local tag by hand. That work scales with the number of consumers and is easy to get wrong.

## Recommendation

**Take Option A.** Cut a new version tag, publish it, and migrate `curfew` to it. Never move `v0.1.0` again. Fingerprint mismatches are only repairable going forward — a tag that has been observed cannot be un-observed, so the cheapest correct move is always a new immutable name, not a corrected old one.

If any consumer is genuinely stuck and needs to move before the migration lands, the local escape hatch is to delete that package's entry from the fingerprint store above and re-resolve. That is a per-machine workaround, not a fix, and it should be recorded when used.

`AGENTS.md` already states the invariant that would have prevented this: *"Tag and publish in a single step… The tag and the npm version must match."* This incident is worth adding to that rule as an explicit *tags are immutable once pushed* clause.
