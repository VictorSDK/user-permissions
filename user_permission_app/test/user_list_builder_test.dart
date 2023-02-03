import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_permission_app/data/models/models.dart';

import 'package:user_permission_app/presentation/Widgets/user_list_builder.dart';

void main() {
  testWidgets('UserListBuilder has user first name and last name', (WidgetTester tester) async {
    final List<User> users = [
      const User(id: '1', firstName: 'John', lastName: 'Smith'),
      const User(id: '2', firstName: 'Clark', lastName: 'Wayne')
    ];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: UserListBuilder(users: users),
      ),
    ));

    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('Clark Wayne'), findsOneWidget);
  });
}
