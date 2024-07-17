class BaseUrls {
  String? _sellerImageUrl;

  BaseUrls({String? sellerImageUrl}) {
    _sellerImageUrl = sellerImageUrl;
  }

  String? get sellerImageUrl => _sellerImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _sellerImageUrl = json['seller_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seller_image_url'] = _sellerImageUrl;
    return data;
  }
}
