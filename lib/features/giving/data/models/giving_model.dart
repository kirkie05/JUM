class GivingTransaction {
  final String id;
  final String userId;
  final String churchId;
  final double amount;
  final String currency;
  final String category; // tithe, offering, donation, seed
  final String gateway; // paystack, stripe
  final String reference;
  final String status;
  final String? receiptUrl;
  final DateTime createdAt;

  const GivingTransaction({
    required this.id,
    required this.userId,
    required this.churchId,
    required this.amount,
    required this.currency,
    required this.category,
    required this.gateway,
    required this.reference,
    required this.status,
    this.receiptUrl,
    required this.createdAt,
  });

  GivingTransaction copyWith({
    String? id,
    String? userId,
    String? churchId,
    double? amount,
    String? currency,
    String? category,
    String? gateway,
    String? reference,
    String? status,
    String? receiptUrl,
    DateTime? createdAt,
  }) {
    return GivingTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      churchId: churchId ?? this.churchId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      gateway: gateway ?? this.gateway,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GivingTransaction.fromJson(Map<String, dynamic> json) {
    return GivingTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      churchId: json['church_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      category: json['category'] as String,
      gateway: json['gateway'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,
      receiptUrl: json['receipt_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'church_id': churchId,
      'amount': amount,
      'currency': currency,
      'category': category,
      'gateway': gateway,
      'reference': reference,
      'status': status,
      'receipt_url': receiptUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class GivingState {
  final String selectedCategory;
  final double amount;
  final bool isRecurring;
  final String frequency; // one_time, weekly, monthly
  final bool isLoading;
  final String? errorMessage;

  const GivingState({
    this.selectedCategory = 'tithe',
    this.amount = 0.0,
    this.isRecurring = false,
    this.frequency = 'one_time',
    this.isLoading = false,
    this.errorMessage,
  });

  GivingState copyWith({
    String? selectedCategory,
    double? amount,
    bool? isRecurring,
    String? frequency,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GivingState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      amount: amount ?? this.amount,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
