import 'dart:ffi';

class AdsAdmin {
  final int id;
  final String regionName;
  final String departmentName;
  final String districtName;
  final int remainingCredits;
  final int originalCredits;
  final bool forOrders;
  final bool forPublications;
  final String pictureURL;
  final String url;
  final String name;
  final DateTime beginningSowingDate;
  final DateTime endingSowingDate;
  final DateTime beginningHarvestDate;
  final DateTime endingHarvestDate;
  final int userId;

  AdsAdmin({
    this.id,
    this.regionName,
    this.departmentName,
    this.districtName,
    this.remainingCredits,
    this.originalCredits,
    this.forOrders,
    this.forPublications,
    this.pictureURL,
    this.url,
    this.name,
    this.beginningSowingDate,
    this.endingSowingDate,
    this.beginningHarvestDate,
    this.endingHarvestDate,
    this.userId,
  });

  factory AdsAdmin.fromJson(Map<String, dynamic> json) {
    return AdsAdmin(
      id: json['id'],
      regionName: json['region']?.name,
      departmentName: json['department']?.name,
      districtName: json['district']?.name,
      remainingCredits: json['remaining_credits'],
      originalCredits: json['original_credits'],
      forOrders: json['for_orders'],
      forPublications: json['for_publications'],
      pictureURL: json['picture_URL'],
      url: json['URL'],
      name: json['name'],
      beginningSowingDate: json['beginning_sowing_date'] != null
          ? DateTime.parse(json['beginning_sowing_date'])
          : null,
      endingSowingDate: json['ending_sowing_date'] != null
          ? DateTime.parse(json['ending_sowing_date'])
          : null,
      beginningHarvestDate: json['beginning_harvest_date'] != null
          ? DateTime.parse(json['beginning_harvest_date'])
          : null,
      endingHarvestDate: json['ending_harvest_date'] != null
          ? DateTime.parse(json['ending_harvest_date'])
          : null,
      userId: json['user'],
    );
  }
}
