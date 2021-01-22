class Department {
  final int id;
  final String name;

  Department(
    {
      this.id,
      this.name
    }
  );

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name']
    );
  }
}