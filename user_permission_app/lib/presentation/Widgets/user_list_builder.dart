import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/user.dart';
import 'package:user_permission_app/presentation/user_permissions_edit_screen.dart';
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
      padding: const EdgeInsets.all(20),
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
            title: Text('${user.firstName} ${user.lastName}'),
            leading: Hero(
                tag: 'userId-${user.id}',
                child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(45, 164, 233, 1),
                    child: Text(user.firstName[0],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white)))),
            trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserPermissionEditScreen(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.edit)));
      },
    );
  }
}
