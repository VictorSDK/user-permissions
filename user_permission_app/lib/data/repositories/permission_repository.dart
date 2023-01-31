import 'dart:convert';
import 'package:user_permission_app/data/interfaces/i_permission_repository.dart';
import 'package:user_permission_app/data/models/permission.dart';
import 'package:http/http.dart' as http;

class PermissionRepository implements IPermissionRepository {  

  List<Permission> parsePermissions(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Permission>((json) => Permission.fromJson(json)).toList();
  }

  Future<List<Permission>> getAll(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://61fc4baf3f1e34001792c875.mockapi.io/api/v1/permissions'));

    if (response.statusCode == 200) {
      var roles = parsePermissions(response.body);
      return roles;
    } else {
      throw Exception('Failed to load permissions');
    }
  }
}