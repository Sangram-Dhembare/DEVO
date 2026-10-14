import 'package:campusvote_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the election and all four workspaces', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    expect(find.text('CampusVote'), findsOneWidget);
    expect(find.text('FEATURED ELECTION'), findsOneWidget);
    expect(find.text('Student Council 2026'), findsOneWidget);
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

  testWidgets('workspace opens a demo placeholder', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    final terminal = find.text('Voting terminal');
    await tester.scrollUntilVisible(terminal, 300);
    await tester.tap(terminal);
    await tester.pumpAndSettle();

    expect(
        find.text('Prototype only. No sign-in, ballot submission, or '
            'election security features are connected.'),
        findsOneWidget);
    expect(find.text('Back to workspaces'), findsOneWidget);
  });
}
