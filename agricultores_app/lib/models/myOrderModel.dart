class MyOrder {
  final int id;
  final String supplieName;
  final String weightUnit;
  final double unitPrice;
  final String areaUnit;
  final double area;
  final DateTime harvestDate;
  final DateTime sowingDate;

  MyOrder({
    this.id,
    this.supplieName,
    this.weightUnit,
    this.unitPrice,
    this.areaUnit,
    this.area,
    this.harvestDate,
    this.sowingDate,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    return MyOrder(
      id: json['id'],
      supplieName: json['supplies']['name'],
      weightUnit: json['weight_unit'],
      unitPrice: json['unit_price'],
      areaUnit: json['area_unit'],
      area: json['area'],
      harvestDate: DateTime.parse(json['desired_harvest_date']),
      sowingDate: DateTime.parse(json['desired_sowing_date']),
    );
  }
}