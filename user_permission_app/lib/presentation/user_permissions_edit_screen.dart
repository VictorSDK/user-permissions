import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:user_permission_app/data/models/models.dart' as data;
import 'package:user_permission_app/data/repositories/permission_repository.dart';
import 'package:user_permission_app/data/repositories/role_repository.dart';
import 'package:user_permission_app/data/repositories/user_permissions_repository.dart';
import 'package:user_permission_app/data/models/user_permissions.dart';

class UserPermissionEditScreen extends StatefulWidget {
  const UserPermissionEditScreen({super.key, required this.user});
  final data.User user;

  @override
  State<UserPermissionEditScreen> createState() => _UserPermissionEditScreen();
}

class _UserPermissionEditScreen extends State<UserPermissionEditScreen> {
  List<data.Role>? _availableRoles;
  List<data.Permission>? _availablePermissions;
  PageStateStatus _status = PageStateStatus.loading;

  UserPermissions? _model;
  final _permissionSet = HashSet<String>();
  final _roleSet = HashSet<String>();
  final _rolesByPermission = <String, List<String>>{};

  @override
  initState() {
    super.initState();

    RoleRepository().getAll().then((List<data.Role> value) {
      _availableRoles = value;
      for (var role in _availableRoles!) {
        for (var permission in role.permissions) {
          if (!_rolesByPermission.containsKey(permission)) {
            _rolesByPermission[permission] = <String>[];
          }
          _rolesByPermission[permission]!.add(role.name);
        }
      }
      _updatePageStatus();
    });

    PermissionRepository().getAll().then((List<data.Permission> value) {
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
        _status = PageStateStatus.loaded;
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
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Hero(
                  tag: 'userId-${widget.user.id}',
                  child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(45, 164, 233, 1),
                      radius: 50,
                      child: Text(widget.user.firstName[0],
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 50, color: Colors.white))),
                ),
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.center,
                    child: Text('${widget.user.firstName} ${widget.user.lastName}',
                        style: Theme.of(context).textTheme.titleLarge!)),
                const SizedBox(height: 20),
                if (_status == PageStateStatus.loading)
                  const Center(child: CircularProgressIndicator()),
                if (_status == PageStateStatus.loaded) ...[
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
            _status = PageStateStatus.loading;
          });
          final newModel = UserPermissions.fromDataModel(widget.user);
          newModel.permissions.addAll(_permissionSet);
          newModel.roles.addAll(_roleSet);
          UserPermissionRepository().upsert(newModel).then((_) {
            setState(() {
              _model = newModel;
              _status = PageStateStatus.loaded;
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
                  final roles = _rolesByPermission[permission.name];
                  _roleSet.removeAll(roles!);
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
              onChanged: (bool? value) {
                if (value == null) return;

                if (value == true) {
                  _roleSet.add(role.name);
                  _permissionSet.addAll(role.permissions);
                } else {
                  _roleSet.remove(role.name);
                  _permissionSet.removeAll(role.permissions);
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

enum PageStateStatus {
  loading,
  loaded,
}
