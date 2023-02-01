import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/user.dart';
import 'package:user_permission_app/data/repositories/user_permissions_repository.dart';
import 'package:user_permission_app/domain/models/user_permissions.dart';

class UserPermissionScreen extends StatelessWidget {
  const UserPermissionScreen({super.key, required this.user});

  final User user;

  Future<UserPermissions> _getUserPermissions(User user) async {
    final userPermissionsResponse = await UserPermissionRepository().get(user.id);
    return userPermissionsResponse ?? UserPermissions.fromDataModel(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.id} - ${user.firstName} ${user.lastName}'),
      ),
      body: FutureBuilder<UserPermissions>(
        future: _getUserPermissions(user),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            final model = snapshot.data!;
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Permissions', style: Theme.of(context).textTheme.titleLarge),
                if (model.permissions.isNotEmpty)
                  ListView.builder(
                    itemCount: model.permissions.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(model.permissions[index]));
                    },
                  )
                else
                  const Text('No permissions found'),
                const SizedBox(height: 10),
                Text('Roles', style: Theme.of(context).textTheme.titleLarge),
                if (model.roles.isNotEmpty)
                  ListView.builder(
                    itemCount: model.roles.length,
                    itemBuilder: (context, index) {
                      final role = model.roles[index];
                      return ListTile(title: Text(role.name));
                    },
                  )
                else
                  const Text('No roles found'),
              ],
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
