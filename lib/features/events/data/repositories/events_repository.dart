import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../models/rsvp_model.dart';

class EventsRepository {
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  EventsRepository(this._supabase);

  Future<List<EventModel>> fetchUpcoming() async {
    // 1. Seed if table is empty
    try {
      final countCheck = await _supabase
          .from('events')
          .select('id')
          .limit(1);
      if (countCheck.isEmpty) {
        await _seedDefaultEvents();
      }
    } catch (e) {
      print('[EVENTS_REPO] Auto-seed check failed: $e');
    }

    // 2. Query published, future events from Supabase ordered by event_date ascending, limit 5
    final response = await _supabase
        .from('events')
        .select()
        .gte('event_date', DateTime.now().toUtc().toIso8601String())
        .eq('is_published', true)
        .order('event_date', ascending: true)
        .limit(5);

    final list = (response as List).map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      map['cover_url'] = map['banner_url'] ?? '';
      return EventModel.fromJson(map);
    }).toList();
    
    return list;
  }

  List<EventModel> _getLocalSeededEvents() {
    final now = DateTime.now();
    final events = [
      {
        'id': 'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
        'title': 'Sunday Worship Service',
        'description': 'Join us for our weekly Sunday service filled with powerful praise, worship, and an impactful word.',
        'event_date': now.add(const Duration(days: 2)).toIso8601String(),
        'location': 'Main Sanctuary, JUM Center',
        'banner_url': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800',
        'is_featured': true,
        'is_published': true,
        'start_time': '09:00 AM',
        'end_time': '12:00 PM',
      },
      {
        'id': '9a0eff76-2319-5da8-b471-6569495d4e76',
        'title': 'Midweek Bible Study',
        'description': 'Deep dive into the scriptures. Bring your questions and let us study together.',
        'event_date': now.add(const Duration(days: 5)).toIso8601String(),
        'location': 'Grace Hall & Online Zoom',
        'banner_url': 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800',
        'is_featured': false,
        'is_published': true,
        'start_time': '06:30 PM',
        'end_time': '08:00 PM',
      },
      {
        'id': '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
        'title': 'Youth Night Encounter',
        'description': 'An exciting evening for youth and young adults featuring dynamic worship and discussions.',
        'event_date': now.add(const Duration(days: 7)).toIso8601String(),
        'location': 'Youth Auditorium',
        'banner_url': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800',
        'is_featured': false,
        'is_published': true,
        'start_time': '07:00 PM',
        'end_time': '09:30 PM',
      }
    ];

    return events.map((json) {
      final map = Map<String, dynamic>.from(json);
      map['cover_url'] = map['banner_url'] ?? '';
      return EventModel.fromJson(map);
    }).toList();
  }

  Future<void> _seedDefaultEvents() async {
    final now = DateTime.now();
    final events = [
      {
        'id': 'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
        'title': 'Sunday Worship Service',
        'description': 'Join us for our weekly Sunday service filled with powerful praise, worship, and an impactful word.',
        'event_date': now.add(const Duration(days: 2)).toIso8601String(),
        'location': 'Main Sanctuary, JUM Center',
        'banner_url': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800',
        'is_featured': true,
        'is_published': true,
        'start_time': '09:00 AM',
        'end_time': '12:00 PM',
      },
      {
        'id': '9a0eff76-2319-5da8-b471-6569495d4e76',
        'title': 'Midweek Bible Study',
        'description': 'Deep dive into the scriptures. Bring your questions and let us study together.',
        'event_date': now.add(const Duration(days: 5)).toIso8601String(),
        'location': 'Grace Hall & Online Zoom',
        'banner_url': 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800',
        'is_featured': false,
        'is_published': true,
        'start_time': '06:30 PM',
        'end_time': '08:00 PM',
      },
      {
        'id': '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
        'title': 'Youth Night Encounter',
        'description': 'An exciting evening for youth and young adults featuring dynamic worship and discussions.',
        'event_date': now.add(const Duration(days: 7)).toIso8601String(),
        'location': 'Youth Auditorium',
        'banner_url': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800',
        'is_featured': false,
        'is_published': true,
        'start_time': '07:00 PM',
        'end_time': '09:30 PM',
      },
      {
        'id': '157443b7-c739-5c3a-b837-652cba4a18b6',
        'title': 'Kingdom Leadership Summit',
        'description': 'Empowering leaders across all domains with solid biblical truths, networking, and strategy.',
        'event_date': now.add(const Duration(days: 14)).toIso8601String(),
        'location': 'Main Auditorium & Live broadcast',
        'banner_url': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=800',
        'is_featured': true,
        'is_published': true,
        'start_time': '09:00 AM',
        'end_time': '01:00 PM',
      },
      {
        'id': 'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
        'title': 'Night of Breakthrough Prayer',
        'description': 'Stand in the gap for nations. A powerful 24-hour prayer chain connecting believers.',
        'event_date': now.add(const Duration(days: 21)).toIso8601String(),
        'location': 'Virtual Assembly & campuses',
        'banner_url': 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=800',
        'is_featured': true,
        'is_published': true,
        'start_time': '10:00 PM',
        'end_time': '06:00 AM',
      }
    ];

    await _supabase.from('events').insert(events);
  }

  Future<RsvpModel?> fetchRsvp(String userId, String eventId) async {
    final response = await _supabase
        .from('event_registrations')
        .select()
        .eq('user_id', userId)
        .eq('event_id', eventId)
        .maybeSingle();

    if (response != null) {
      return RsvpModel.fromJson(response);
    }
    return null;
  }

  Future<RsvpModel> createRsvp(String userId, String eventId) async {
    final String uuidStr = _uuid.v4();
    final String qrPayload = 'JUM-$eventId-$userId-$uuidStr';
    final rsvpId = _uuid.v4();

    final rsvp = RsvpModel(
      id: rsvpId,
      userId: userId,
      eventId: eventId,
      qrCode: qrPayload,
      createdAt: DateTime.now(),
    );

    await _supabase.from('event_registrations').insert(rsvp.toJson());

    return rsvp;
  }

  Future<EventModel?> fetchEvent(String eventId) async {
    final response = await _supabase
        .from('events')
        .select()
        .eq('id', eventId)
        .maybeSingle();
    if (response != null) {
      final map = Map<String, dynamic>.from(response as Map);
      map['cover_url'] = map['banner_url'] ?? '';
      return EventModel.fromJson(map);
    }
    return null;
  }
}
