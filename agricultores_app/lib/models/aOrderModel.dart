class AOrder {
  final int id;
  final String supplieName;
  final String weightUnit;
  final double unitPrice;
  final String areaUnit;
  final double area;
  final DateTime harvestDate;
  final DateTime sowingDate;
  final bool isSolved;
  final int userId;
  final String userPhoneNumber;

  AOrder({
    this.id,
    this.supplieName,
    this.weightUnit,
    this.unitPrice,
    this.areaUnit,
    this.area,
    this.harvestDate,
    this.sowingDate,
    this.isSolved,
    this.userId,
    this.userPhoneNumber,
  });

  factory AOrder.fromJson(Map<String, dynamic> json) {
    return AOrder(
      id: json['id'],
      supplieName: json['supplies']['name'],
      weightUnit: json['weight_unit'],
      unitPrice: json['unit_price'],
      areaUnit: json['area_unit'],
      area: json['area'],
      isSolved: json['is_solved'],
      harvestDate: DateTime.parse(json['desired_harvest_date']),
      sowingDate: DateTime.parse(json['desired_sowing_date']),
      userId: json['user'],
      userPhoneNumber: json['user_phone_number'],
    );
  }
}
