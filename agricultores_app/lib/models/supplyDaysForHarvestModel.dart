class SupplyDaysForHarvest {
  final String name;
  final int days;

  SupplyDaysForHarvest({this.name, this.days});

  factory SupplyDaysForHarvest.fromJson(Map<String, dynamic> json) {
    return SupplyDaysForHarvest(
      name: json['name'],
      days: json['days'],
    );
  }

}