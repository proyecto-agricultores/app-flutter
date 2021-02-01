class MyPub {
  final int id;
  final String supplieName;
  final String pictureURL;
  final String weightUnit;
  final double unitPrice;
  final String areaUnit;
  final double area;
  final DateTime harvestDate;
  final DateTime sowingDate;

  MyPub({
    this.id,
    this.supplieName,
    this.pictureURL,
    this.weightUnit,
    this.unitPrice,
    this.areaUnit,
    this.area,
    this.harvestDate,
    this.sowingDate,
  });

  factory MyPub.fromJson(Map<String, dynamic> json) {
    return MyPub(
      id: json['id'],
      supplieName: json['supplies']['name'],
      pictureURL: json['picture_URL'],
      weightUnit: json['weight_unit'],
      unitPrice: json['unit_price'],
      areaUnit: json['area_unit'],
      area: json['area'],
      harvestDate: DateTime.parse(json['harvest_date']),
      sowingDate: DateTime.parse(json['sowing_date']),
    );
  }
}
