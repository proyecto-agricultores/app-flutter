class District {
  final int id;
  final String name;

  District(
    {
      this.id,
      this.name
    }
  );

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name']
    );
  }
}