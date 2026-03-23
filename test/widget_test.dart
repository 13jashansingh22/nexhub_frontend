import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexmeet_games_mobile/app/app.dart';

void main() {
  testWidgets('App renders NexMeet Games hub', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NexMeetGamesApp()));
    await tester.pumpAndSettle();

    expect(find.text('NexMeet Games'), findsWidgets);
    expect(find.text('Play. Compete. Level Up.'), findsOneWidget);
  });
}
