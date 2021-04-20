class Supply {
  final int id;
  final String name;
  final int daysToHarvest;

  Supply({this.id, this.name, this.daysToHarvest});

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(id: json['id'], name: json['name'], daysToHarvest: json['days_for_harvest']);
  }
}
