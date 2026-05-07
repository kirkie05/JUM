class RsvpModel {
  final String id;
  final String userId;
  final String eventId;
  final String qrCode;
  final DateTime createdAt;

  RsvpModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.qrCode,
    required this.createdAt,
  });

  factory RsvpModel.fromJson(Map<String, dynamic> json) {
    return RsvpModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      eventId: json['event_id'] as String? ?? json['eventId'] as String? ?? '',
      qrCode: json['qr_code'] as String? ?? json['qrCode'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'qr_code': qrCode,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
