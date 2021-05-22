class Ad {
  final bool displayAdd;
  final String targetUrl;
  final String imageUrl;
  final String phoneNumber;
  final int idAdvertiser;

  Ad({
    this.displayAdd,
    this.targetUrl,
    this.imageUrl,
    this.phoneNumber,
    this.idAdvertiser,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      displayAdd: json['data'],
      targetUrl: json['URL'],
      imageUrl: json['picture_URL'],
      phoneNumber: json['phone_number'],
      idAdvertiser: json['id_advertiser'],
    );
  }
}
