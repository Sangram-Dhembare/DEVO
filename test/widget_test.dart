import 'package:campusvote_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the election and all four workspaces', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    expect(find.text('CampusVote'), findsOneWidget);
    expect(find.text('Student Council 2026'), findsOneWidget);
    expect(find.text('Admin dashboard'), findsOneWidget);
    expect(find.text('Check-in desk'), findsOneWidget);
    expect(find.text('Voting terminal'), findsOneWidget);
    expect(find.text('Trustee tool'), findsOneWidget);
  });

  testWidgets('workspace opens a demo placeholder', (tester) async {
    await tester.pumpWidget(const CampusVoteApp());

    final terminal = find.text('Voting terminal');
    await tester.ensureVisible(terminal);
    await tester.tap(terminal);
    await tester.pumpAndSettle();

    expect(find.text('Prototype only. No sign-in, ballot submission, or '
        'election security features are connected.'), findsOneWidget);
    expect(find.text('Back to workspaces'), findsOneWidget);
  });
}
