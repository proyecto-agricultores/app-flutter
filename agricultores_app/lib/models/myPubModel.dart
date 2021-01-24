class MyPub {
  final int id;
  final String supplieName;
  final String pictureURL;
  final String unit;
  final int quantity;
  final DateTime harvestDate;
  final DateTime sowingDate;
  final double unitPrice;

  MyPub(
      {this.id,
      this.supplieName,
      this.pictureURL,
      this.unit,
      this.quantity,
      this.harvestDate,
      this.sowingDate,
      this.unitPrice});

  factory MyPub.fromJson(Map<String, dynamic> json) {
    return MyPub(
      id: json['id'],
      supplieName: json['supplies']['name'],
      pictureURL: json['picture_URL'],
      unit: json['unit'],
      quantity: json['quantity'],
      harvestDate: DateTime.parse(json['harvest_date']),
      sowingDate: DateTime.parse(json['sowing_date']),
      unitPrice: json['unit_price'],
    );
  }
}
