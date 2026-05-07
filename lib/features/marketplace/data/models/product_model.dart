class ProductModel {
  final String id;
  final String churchId;
  final String title;
  final String description;
  final String type; // 'digital' | 'physical'
  final double price;
  final String currency;
  final String mediaUrl;
  final int stock;
  final bool isActive;
  bool get isDigital => type == 'digital';
  String get imageUrl => mediaUrl;

  ProductModel({
    required this.id,
    required this.churchId,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    this.currency = 'USD',
    required this.mediaUrl,
    required this.stock,
    required this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      churchId: json['church_id'] as String? ?? json['churchId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'physical',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      mediaUrl: json['media_url'] as String? ?? json['mediaUrl'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'title': title,
      'description': description,
      'type': type,
      'price': price,
      'currency': currency,
      'media_url': mediaUrl,
      'stock': stock,
      'is_active': isActive,
    };
  }
}
