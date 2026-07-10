import 'dart:convert';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String coverUrl;
  final bool isPaid;
  final double ticketPrice;
  final String? startTime;
  final String? endTime;
  final bool isPublished;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.coverUrl,
    required this.isPaid,
    required this.ticketPrice,
    this.startTime,
    this.endTime,
    this.isPublished = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['event_date'] != null ? DateTime.parse(json['event_date'] as String) : (json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now()),
      location: json['location'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      isPaid: json['is_paid'] as bool? ?? json['isPaid'] as bool? ?? false,
      ticketPrice: (json['ticket_price'] as num?)?.toDouble() ?? (json['ticketPrice'] as num?)?.toDouble() ?? 0.0,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': date.toIso8601String(),
      'date': date.toIso8601String(),
      'location': location,
      'cover_url': coverUrl,
      'is_paid': isPaid,
      'ticket_price': ticketPrice,
      'start_time': startTime,
      'end_time': endTime,
      'is_published': isPublished,
    };
  }
}
