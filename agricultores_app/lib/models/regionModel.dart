class Region {
  final int id;
  final String name;

  Region(
    {
      this.id,
      this.name
    }
  );

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name']
    );
  }
}