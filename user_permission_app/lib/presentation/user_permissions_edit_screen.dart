import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/models.dart';
import 'package:user_permission_app/data/repositories/permission_repository.dart';
import 'package:user_permission_app/data/repositories/role_repository.dart';
import 'package:user_permission_app/data/repositories/user_permissions_repository.dart';
import 'package:user_permission_app/presentation/page_state_status.dart';
import 'package:user_permission_app/presentation/user_avatar.dart';

class UserPermissionEditScreen extends StatefulWidget {
  const UserPermissionEditScreen({super.key, required this.user});
  final User user;

  @override
  State<UserPermissionEditScreen> createState() => _UserPermissionEditScreen();
}

class _UserPermissionEditScreen extends State<UserPermissionEditScreen> {
  List<Role>? _availableRoles;
  List<Permission>? _availablePermissions;
  PageStateStatus _pageStatus = PageStateStatus.loading;

  UserPermissions? _model;
  final _permissionSet = HashSet<String>();
  final _roleSet = HashSet<String>();

  @override
  initState() {
    super.initState();

    RoleRepository().getAll().then((List<Role> value) {
      _availableRoles = value;
      _updatePageStatus();
    });

    PermissionRepository().getAll().then((List<Permission> value) {
      _availablePermissions = value;
      _updatePageStatus();
    });

    UserPermissionRepository().get(widget.user.id).then((UserPermissions? value) {
      _model = value ?? UserPermissions.fromDataModel(widget.user);
      _permissionSet.addAll(_model!.permissions);
      _roleSet.addAll(_model!.roles);
      _updatePageStatus();
    });
  }

  void _updatePageStatus() {
    if (_model != null && _availableRoles != null && _availablePermissions != null) {
      setState(() {
        _pageStatus = PageStateStatus.loaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(45, 164, 233, 1),
          title: const Text('Manage Permission and Roles'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            child: ListView(
              children: [
                UserAvatar(user: widget.user),
                if (_pageStatus == PageStateStatus.loading)
                  const Center(child: CircularProgressIndicator()),
                if (_pageStatus == PageStateStatus.loaded) ...[
                  _buildPermissionsCheckBoxList(context),
                  const SizedBox(height: 20),
                  _buildRolesCheckBoxList(context),
                  const SizedBox(height: 20),
                  _buildSaveButton(context)
                ]
              ],
            ),
          ),
        ));
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _pageStatus = PageStateStatus.loading;
          });
          final newModel = UserPermissions.fromDataModel(widget.user);
          newModel.permissions.addAll(_permissionSet);
          newModel.roles.addAll(_roleSet);
          UserPermissionRepository().upsert(newModel).then((_) {
            setState(() {
              _model = newModel;
              _pageStatus = PageStateStatus.loaded;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Save',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
        ));
  }

  Widget _buildPermissionsCheckBoxList(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Permissions',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _availablePermissions!.length,
          itemBuilder: (context, index) {
            var permission = _availablePermissions![index];
            return CheckboxListTile(
              title: Text(permission.name),
              onChanged: (bool? value) {
                if (value == null) return;

                if (value == true) {
                  _permissionSet.add(permission.name);
                } else {
                  _permissionSet.remove(permission.name);
                }
                setState(() {});
              },
              value: _permissionSet.contains(permission.name),
            );
          },
        ),
      ],
    ));
  }

  Widget _buildRolesCheckBoxList(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Roles',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _availableRoles!.length,
          itemBuilder: (context, index) {
            var role = _availableRoles![index];
            return CheckboxListTile(
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
              onChanged: (bool? value) {
                if (value == null) return;

                if (value == true) {
                  _roleSet.add(role.name);
                } else {
                  _roleSet.remove(role.name);
                }
                setState(() {});
              },
              value: _roleSet.contains(role.name),
            );
          },
        ),
      ],
    ));
  }
}
