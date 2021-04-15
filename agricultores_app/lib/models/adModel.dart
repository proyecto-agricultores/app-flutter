class Ad {
  final bool displayAdd;
  final String targetUrl;
  final String imageUrl;

  Ad({this.displayAdd, this.targetUrl, this.imageUrl});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      displayAdd: json['data'],
      targetUrl: json['URL'],
      imageUrl: json['picture_URL'],
    );
  }
}
