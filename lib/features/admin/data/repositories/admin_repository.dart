import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';

class AdminOverviewStats {
  final int totalMembers;
  final double monthlyGiving;
  final int enrolledStudents;
  final int activeGroups;

  AdminOverviewStats({
    required this.totalMembers,
    required this.monthlyGiving,
    required this.enrolledStudents,
    required this.activeGroups,
  });
}

class AdminRepository {
  final SupabaseClient _supabase;
  AdminRepository(this._supabase);

  Future<AdminOverviewStats> fetchOverviewStats() async {
    // Total Members
    final memRes = await _supabase.from('profiles').select('id').count(CountOption.exact);
    final totalMembers = memRes.count;

    // Monthly Giving
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
    final giveRes = await _supabase
        .from('donations')
        .select('amount')
        .gte('created_at', firstDayOfMonth);
    
    double monthlyGiving = 0.0;
    for (var row in giveRes as List) {
      monthlyGiving += (row['amount'] as num).toDouble();
    }

    // Enrolled Students
    final stuRes = await _supabase.from('enrollments').select('user_id').count(CountOption.exact);
    final enrolledStudents = stuRes.count;

    // Active Groups
    final grpRes = await _supabase.from('groups').select('id').count(CountOption.exact);
    final activeGroups = grpRes.count;

    return AdminOverviewStats(
      totalMembers: totalMembers,
      monthlyGiving: monthlyGiving,
      enrolledStudents: enrolledStudents,
      activeGroups: activeGroups,
    );
  }

  Future<List<Map<String, dynamic>>> fetchRecentActivities() async {
    // In a real app, you might have an 'activities' table or union several tables.
    // Here we construct a small log from recent donations and enrollments.
    final list = <Map<String, dynamic>>[];
    
    try {
      final donations = await _supabase.from('donations')
          .select('id, amount, category, created_at, profiles(full_name)')
          .order('created_at', ascending: false)
          .limit(3);
          
      for (var d in donations as List) {
        final name = d['profiles']?['full_name'] ?? 'A member';
        final amount = d['amount'];
        final cat = d['category'];
        list.add({
          'text': '$name contributed \$$amount for $cat',
          'time': d['created_at'],
        });
      }
      
      final enrollments = await _supabase.from('enrollments')
          .select('created_at, profiles(full_name), courses(title)')
          .order('created_at', ascending: false)
          .limit(2);
          
      for (var e in enrollments as List) {
        final name = e['profiles']?['full_name'] ?? 'A student';
        final title = e['courses']?['title'] ?? 'a course';
        list.add({
          'text': '$name enrolled in $title',
          'time': e['created_at'],
        });
      }
      
      list.sort((a, b) => DateTime.parse(b['time']).compareTo(DateTime.parse(a['time'])));
    } catch (e) {
      // Ignored
    }
    
    return list;
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final res = await _supabase.from('profiles').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    await _supabase.from('profiles').update({'role': newRole}).eq('id', userId);
  }

  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    try {
      final res = await _supabase.from('groups').select();
      return List<Map<String, dynamic>>.from(res as List);
    } catch(e) { return []; }
  }

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      final res = await _supabase.from('events').select().order('date', ascending: true);
      return List<Map<String, dynamic>>.from(res as List);
    } catch(e) { return []; }
  }

  Future<List<Map<String, dynamic>>> fetchDonations() async {
    try {
      final res = await _supabase.from('donations').select('id, amount, category, gateway, created_at, profiles(full_name)').order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(res as List);
    } catch(e) { return []; }
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(supabaseClientProvider));
});
