import 'dart:convert';

class EventModel {
  final String id;
  final String churchId;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String coverUrl;
  final bool isPaid;
  final double ticketPrice;

  EventModel({
    required this.id,
    required this.churchId,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.coverUrl,
    required this.isPaid,
    required this.ticketPrice,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String? ?? '',
      churchId: json['church_id'] as String? ?? json['churchId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      location: json['location'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      isPaid: json['is_paid'] as bool? ?? json['isPaid'] as bool? ?? false,
      ticketPrice: (json['ticket_price'] as num?)?.toDouble() ?? (json['ticketPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'cover_url': coverUrl,
      'is_paid': isPaid,
      'ticket_price': ticketPrice,
    };
  }
}
