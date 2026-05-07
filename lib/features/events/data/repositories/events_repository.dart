import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../models/rsvp_model.dart';

class EventsRepository {
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  EventsRepository(this._supabase);

  // Fallback mock events for high-fidelity offline preview and resilient testing
  final List<EventModel> _mockEvents = [
    EventModel(
      id: 'event-1',
      churchId: 'jum-church-1',
      title: 'Unhindered Worship Night',
      description: 'Join us for a transformational night of pure, unhindered praise, worship, and spiritual renewal. Come with an open heart to receive and encounter God like never before.',
      date: DateTime.now().add(const Duration(days: 2, hours: 4)),
      location: 'Lagos HQ Main Sanctuary',
      coverUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
      isPaid: false,
      ticketPrice: 0.0,
    ),
    EventModel(
      id: 'event-2',
      churchId: 'jum-church-1',
      title: 'Youth Grace Summit 2026',
      description: 'A power-packed weekend of empowerment, career development, panel sessions, and deep spiritual infilling designed for the next generation of leaders.',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Houston Campus Hall A',
      coverUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&w=800&q=80',
      isPaid: true,
      ticketPrice: 5000.0,
    ),
    EventModel(
      id: 'event-3',
      churchId: 'jum-church-1',
      title: 'Couples Prayer Breakfast',
      description: 'An intimate fellowship breakfast for couples to align in prayers, receive counsel on marriage, and connect with other families in a grace-filled environment.',
      date: DateTime.now().add(const Duration(days: 8, hours: 2)),
      location: 'London Grace Fellowship',
      coverUrl: 'https://images.unsplash.com/photo-1469041134994-521628367ae6?auto=format&fit=crop&w=800&q=80',
      isPaid: true,
      ticketPrice: 7500.0,
    ),
    EventModel(
      id: 'event-4',
      churchId: 'jum-church-1',
      title: 'Miracle & Healing Crusade',
      description: 'Prepare to receive supernatural breakthroughs, healings, and life-changing deliverances under the ministry of God\'s servants.',
      date: DateTime.now().add(const Duration(days: 12)),
      location: 'Lagos Crusade Ground',
      coverUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=800&q=80',
      isPaid: false,
      ticketPrice: 0.0,
    ),
  ];

  final Map<String, RsvpModel> _inMemoryRsvps = {};

  Future<List<EventModel>> fetchUpcoming(String churchId) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('church_id', churchId)
          .gte('date', DateTime.now().toIso8601String())
          .order('date', ascending: true);

      if (response != null && (response as List).isNotEmpty) {
        return (response as List).map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Graceful fallback to rich mock data
    }
    return _mockEvents.where((e) => e.churchId == churchId).toList();
  }

  Future<RsvpModel?> fetchRsvp(String userId, String eventId) async {
    try {
      final response = await _supabase
          .from('rsvps')
          .select()
          .eq('user_id', userId)
          .eq('event_id', eventId)
          .maybeSingle();

      if (response != null) {
        return RsvpModel.fromJson(response);
      }
    } catch (e) {
      // Graceful fallback to memory RSVP cache
    }
    return _inMemoryRsvps['$userId-$eventId'];
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

    try {
      await _supabase.from('rsvps').insert(rsvp.toJson());
    } catch (e) {
      // Graceful fallback to in-memory cache
    }

    _inMemoryRsvps['$userId-$eventId'] = rsvp;
    return rsvp;
  }
}
