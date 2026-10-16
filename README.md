# CampusVote Flutter app

This is the initial Flutter app foundation for CampusVote,
It provides a role launcher for the four client surfaces in the specification:

- Election administration
- Check-in desk
- Voting terminal
- Trustee tool

The role destinations are intentionally demo placeholders. The app does not
authenticate voters, read NFC cards, issue tokens, encrypt ballots, submit
votes, or publish anything to Solana. Do not use it to run a real election.
`lib/election_config.dart` implements the first Phase 1 building block: parsing
and validating the election configuration format from `DEVO.pdf` and hashing
its canonical JSON representation with SHA-256. The voter roll, Merkle root,
and cryptographic core are not implemented; security-critical cryptography
must use the Rust implementation called for by the spec, not Dart.

## Run

Install the Flutter SDK, then from this directory run:

```sh
flutter pub get
flutter run
```

Run the widget tests with:

```sh
flutter test
```

## Next implementation steps

Continue Phase 1 in `DEVO.pdf`: implement voter-roll handling and Merkle-root
generation, then the Rust cryptographic core and tally tests. Build the backend
and separate role applications only after these foundations are in place.
