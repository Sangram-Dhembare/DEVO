# CampusVote Flutter app

This is the initial Flutter app foundation for CampusVote, based on `DEVO.pdf`.
It provides a role launcher for the four client surfaces in the specification:

- Election administration
- Check-in desk
- Voting terminal
- Trustee tool

The role destinations are intentionally demo placeholders. This app does not
authenticate voters, read NFC cards, issue tokens, encrypt ballots, submit
votes, or publish anything to Solana. Do not use it to run a real election.
The cryptographic core must be implemented and reviewed separately; the spec
calls for Rust rather than Dart for security-critical cryptography.

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

Follow the build order to implement and test the election
configuration, voter roll, and cryptographic core before wiring any client
flow to a real backend. Split the role destinations into separate applications
when their device permissions and deployment requirements are introduced.
