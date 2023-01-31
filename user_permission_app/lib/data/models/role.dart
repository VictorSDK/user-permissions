class Role {
  final String id;
  final String name;
  final List<String> permissions;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      name: json['name'] as String,
      permissions: [...?json['permissions']],
    );
  }
}