import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/user.dart';
import 'package:user_permission_app/presentation/user_permissions_screen.dart';

class UserListBuilder extends StatefulWidget {
  const UserListBuilder({
    super.key,
    required this.users,
  });

  final List<User> users;

  @override
  State<UserListBuilder> createState() => _UserListBuilderState();
}

class _UserListBuilderState extends State<UserListBuilder> {
   
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        var user = widget.users[index];
        return ListTile(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserPermissionScreen(user: user),
              ),
            )
          },
          title: Text('${user.id} - ${user.firstName} ${user.lastName}')
        );
      },
    );
  }
}