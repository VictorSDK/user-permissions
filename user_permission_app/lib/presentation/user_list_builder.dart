import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/user.dart';

class UserListBuilder extends StatefulWidget {
  const UserListBuilder({
    super.key,
    required this.selectedList,
    required this.users,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<bool> selectedList;
  final List<User> users;
  final Function(bool)? onSelectionChange;

  @override
  State<UserListBuilder> createState() => _UserListBuilderState();
}

class _UserListBuilderState extends State<UserListBuilder> {
 
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        var user = widget.users[index];
        return ListTile(
          onTap: () => _toggle(index),
          title: Text('${user.id} - ${user.firstName} ${user.lastName}')
        );
      },
    );
  }
}