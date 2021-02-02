class Supply {
  final int id;
  final String name;

  Supply({this.id, this.name});

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(id: json['id'], name: json['name']);
  }
}
