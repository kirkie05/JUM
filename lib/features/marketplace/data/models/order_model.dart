import 'product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final String productId;
  final String stripePiId;
  final String status;
  final DateTime createdAt;
  final ProductModel? product;

  OrderModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.stripePiId,
    required this.status,
    required this.createdAt,
    this.product,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      productId: json['product_id'] as String? ?? json['productId'] as String? ?? '',
      stripePiId: json['stripe_pi_id'] as String? ?? json['stripePiId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      product: json['product'] != null ? ProductModel.fromJson(json['product'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'stripe_pi_id': stripePiId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }
}
