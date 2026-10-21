import 'package:campusvote_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('administration workspace opens as a prototype', (tester) async {
    await _openWorkspace(tester, 'Admin dashboard');

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Admin dashboard'),
      ),
      findsOneWidget,
    );
    expect(find.text('Back to workspaces'), findsOneWidget);
    expect(find.textContaining('Prototype only.'), findsOneWidget);
  });

  testWidgets('check-in workspace opens as a prototype', (tester) async {
    await _openWorkspace(tester, 'Check-in desk');

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Check-in desk'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Prototype only.'), findsOneWidget);
  });

  testWidgets('voting workspace opens as a local prototype', (tester) async {
    await _openWorkspace(tester, 'Voting terminal');

    expect(find.text('Student Council 2026'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Review ballot'), 300);
    expect(find.text('Review ballot'), findsOneWidget);
    expect(find.textContaining('Prototype only.'), findsOneWidget);
  });

  testWidgets('trustee workspace opens as a prototype', (tester) async {
    await _openWorkspace(tester, 'Trustee tool');

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Trustee tool'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Prototype only.'), findsOneWidget);
  });

  testWidgets('uses a consistent light system color palette', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    final theme = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;
    expect(theme.colorScheme.primary, const Color(0xFF007AFF));
    expect(theme.colorScheme.secondary, const Color(0xFF34C759));
    expect(theme.scaffoldBackgroundColor, const Color(0xFFF2F2F7));
    expect(theme.cardTheme.color, const Color(0xFFFFFFFF));
  });

  testWidgets('shows the election and all four workspaces', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    expect(find.text('CampusVote'), findsOneWidget);
    expect(find.text('DEMO'), findsNothing);
    expect(find.text('FEATURED ELECTION'), findsOneWidget);
    expect(find.text('Student Council 2026'), findsOneWidget);
    expect(find.text('On-chain integration'), findsOneWidget);
    expect(find.text('No contract or testnet integration'), findsOneWidget);
    expect(find.text('NOT IMPLEMENTED'), findsOneWidget);
    for (final workspace in [
      'Admin dashboard',
      'Check-in desk',
      'Voting terminal',
      'Trustee tool',
    ]) {
      final finder = find.text(workspace);
      await tester.scrollUntilVisible(finder, 300);
      expect(finder, findsOneWidget);
    }
  });

  testWidgets('other workspaces keep their prototype placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusVoteApp());

    final adminWorkspace = find.text('Admin dashboard');
    await tester.scrollUntilVisible(adminWorkspace, 300);
    await tester.tap(adminWorkspace);
    await tester.pumpAndSettle();

    expect(
        find.text('Prototype only. No sign-in, ballot submission, or '
            'election security features are connected.'),
        findsOneWidget);
    expect(find.text('Back to workspaces'), findsOneWidget);
  });

  testWidgets('voting terminal reviews local selections without submitting', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusVoteApp());

    final terminal = find.text('Voting terminal');
    await tester.scrollUntilVisible(terminal, 300);
    await tester.tap(terminal);
    await tester.pumpAndSettle();

    expect(find.text('Student Council 2026'), findsOneWidget);
    expect(
      find.text('Choose a candidate for each position to continue.'),
      findsOneWidget,
    );

    final presidentChoice = find.text('Avery Chen');
    await tester.scrollUntilVisible(presidentChoice, 300);
    await tester.tap(presidentChoice);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Student Council 2026'),
      -300,
    );
    expect(
      find.text('Choose a candidate for each position to continue.'),
      findsOneWidget,
    );

    final vicePresidentChoice = find.text('Riley Kim');
    await tester.scrollUntilVisible(vicePresidentChoice, 300);
    await tester.tap(vicePresidentChoice);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Student Council 2026'),
      -300,
    );
    expect(
      find.text('Both positions selected. Your ballot is ready to review.'),
      findsOneWidget,
    );

    final reviewButton = find.text('Review ballot');
    await tester.scrollUntilVisible(reviewButton, 300);
    await tester.tap(reviewButton);
    await tester.pumpAndSettle();

    final reviewDialog = find.byType(AlertDialog);
    expect(find.text('Review your selections'), findsOneWidget);
    expect(
      find.descendant(of: reviewDialog, matching: find.text('Avery Chen')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: reviewDialog, matching: find.text('Riley Kim')),
      findsOneWidget,
    );
    expect(
      find.text('Prototype only. These selections are not submitted or saved.'),
      findsOneWidget,
    );
    expect(find.text('Submit vote'), findsNothing);
  });

  testWidgets('clears local ballot selections before review', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    final terminal = find.text('Voting terminal');
    await tester.scrollUntilVisible(terminal, 300);
    await tester.tap(terminal);
    await tester.pumpAndSettle();

    final presidentChoice = find.text('Avery Chen');
    await tester.scrollUntilVisible(presidentChoice, 300);
    await tester.tap(presidentChoice);
    await tester.pump();

    final clearButton = find.text('Clear selections');
    await tester.scrollUntilVisible(clearButton, -300);
    await tester.tap(clearButton);
    await tester.pump();

    expect(find.text('0 / 2'), findsOneWidget);
    expect(
      find.text('Choose a candidate for each position to continue.'),
      findsOneWidget,
    );
  });
}

Future<void> _openWorkspace(WidgetTester tester, String title) async {
  await tester.pumpWidget(const CampusVoteApp());
  final workspace = find.text(title);
  await tester.scrollUntilVisible(workspace, 300);
  await tester.tap(workspace);
  await tester.pumpAndSettle();
}
