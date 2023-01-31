class Permission {
  final String id;
  final String name;

  const Permission({
    required this.id,
    required this.name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}