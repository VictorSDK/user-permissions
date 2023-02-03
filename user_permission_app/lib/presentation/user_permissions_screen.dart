import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/models.dart';
import 'package:user_permission_app/data/repositories/role_repository.dart';
import 'package:user_permission_app/data/repositories/user_permissions_repository.dart';
import 'package:user_permission_app/presentation/user_avatar.dart';

class UserPermissionScreen extends StatelessWidget {
  const UserPermissionScreen({super.key, required this.user});

  final User user;

  Future<PermissionsAndRoles> _getUserPermissions(User user) async {
    final userPermissions = await UserPermissionRepository().get(user.id);

    if (userPermissions == null) {
      return PermissionsAndRoles(permissions: <String>[], roles: <Role>[]);
    }

    var userRoles = <Role>[];
    if (userPermissions.roles.isNotEmpty) {
      final roles = await RoleRepository().getAll();

      for (var roleName in userPermissions.roles) {
        userRoles.add(roles.firstWhere((e) => e.name == roleName));
      }
    }

    return PermissionsAndRoles(permissions: userPermissions.permissions, roles: userRoles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(45, 164, 233, 1),
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Column(
        children: [
          UserAvatar(user: user),
          Expanded(
            child: FutureBuilder<PermissionsAndRoles>(
              future: _getUserPermissions(user),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData) {
                  final model = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Text('Permissions',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                          if (model.permissions.isNotEmpty)
                            ListView.builder(
                              padding: const EdgeInsets.all(15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.permissions.length,
                              itemBuilder: (context, index) {
                                return ListTile(title: Text(model.permissions[index]));
                              },
                            )
                          else
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text('No permissions found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.grey))),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Text('Roles',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                          if (model.roles.isNotEmpty)
                            ListView.builder(
                              padding: const EdgeInsets.all(15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.roles.length,
                              itemBuilder: (context, index) {
                                final role = model.roles[index];
                                return ListTile(
                                  title: Text(role.name),
                                  subtitle: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: role.permissions.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(role.permissions[index]),
                                        );
                                      }),
                                );
                              },
                            )
                          else
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text('No roles found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.grey))),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionsAndRoles {
  PermissionsAndRoles({required this.permissions, required this.roles});

  final List<String> permissions;
  final List<Role> roles;
}
