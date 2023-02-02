import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Hero(
            tag: 'userId-${user.id}',
            child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(45, 164, 233, 1),
                radius: 50,
                child: Text(user.firstName[0],
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 50, color: Colors.white))),
          ),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.center,
              child: Text('${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.titleLarge!)),
        ],
      ),
    );
  }
}
