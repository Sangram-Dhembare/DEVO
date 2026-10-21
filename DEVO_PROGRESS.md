# CampusVote progress note

Last updated: 21 October 2026

This file is a handoff note for the next development session. Use
`DEVO_Implementation_Roadmap.pdf` for the ordered plan and `DEVO.pdf` as the
project specification.

## Completed so far

- Flutter starter app with a CampusVote launcher and four role workspaces.
- Local voting-terminal UI for the example election: one candidate per
  position, selection progress and guidance, ballot review, and a clear
  selections action. The demo does not save or submit votes.
- Typed election-configuration parsing, validation, JSON serialization, and
  SHA-256 configuration hashing in `lib/election_config.dart`.
- Configuration tests for valid input, stable round-tripping and hashes,
  malformed roots, duplicate identifiers, unknown fields, voting-window
  validation, and trustee thresholds.
- Widget tests for launcher/workspace navigation, ballot selection/review, and
  clearing selections.
- Flutter lint dependency and clean static analysis.
- The app has been built and launched in the Android emulator during prior
  work.
- Explicit compact canonical JSON serialization and UTF-8 SHA-256 hashing.
- Tests for independent fixed digest vector, input key-order and whitespace
  invariance, valid field-change sensitivity, invalid integer types, and smoke
  coverage for each of the four role workspaces.
- Honest README describing the app-layer prototype, architecture, run/test
  steps, limitations, and roadmap. No Rust source or on-chain component exists
  in this repository.
- GitHub Actions workflow for Flutter formatting, analysis, and tests; ignore
  rules for environment files, keystores, Google services config, and build
  outputs.
- Local implementation commit: `5410596 Make DEVO prototype verifiable and
  honest`.

## Current verification

- `dart format --output=none --set-exit-if-changed lib test` — passed.
- `flutter analyze` — no issues found.
- `flutter test` — all 19 tests pass.
- Fresh-clone verification: `flutter pub get`, format check, analysis, and all
  19 tests pass.
- Independently computed the fixed configuration digest with `shasum -a 256`;
  it matches the expected test vector.
- macOS debug build completed and Flutter hot restart succeeded.
- CI workflow YAML syntax and ignore rules were checked. `actionlint` was not
  available locally.
- The ballot UI is a prototype only. No election backend or cryptographic
  service is connected.

## Still to do

1. **Phase 1:** define and validate the voter-roll input and implement the
   Merkle root.
2. **Phase 1:** implement the security-critical cryptographic core in Rust,
   bind it to Flutter, and add specification-vector and property tests for
   encryption, proofs, aggregation, threshold decryption, and tallying.
3. **Phase 2:** build the Rust/Axum API and PostgreSQL ledger, then implement
   election setup/lock, roll upload, check-in/token issuance, ballot
   verification/submission, nullifiers, receipts, and trustee flows.
4. **Later phases:** build separate check-in and voting apps, implement NFC
   card validation, Solana/Anchor anchoring, offline booth hardening, and a
   supervised pilot, in the order described by the roadmap.

## Safety boundary

Do not describe the current app as election-ready or use it to conduct a real
election. Authentication, NFC, ballot encryption, vote submission, tallying,
Solana integration, and the production backend are not implemented. Keep
election cryptography in the specified Rust core rather than Dart.

## Recommended next step

Start Phase 1 item 2: implement voter-roll validation and deterministic Merkle
root generation, using the exact input and hashing requirements in `DEVO.pdf`.
