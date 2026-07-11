with open('lib/features/admin/data/repositories/admin_repository.dart', 'r') as f:
    content = f.read()

content = content.replace("}\n\nfinal adminRepositoryProvider", """
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

final adminRepositoryProvider""")

content = content.replace("""  Future<List<Map<String, dynamic>>> fetchDonations() async {
    final res = await _supabase.from('donations').select('id, amount, category, gateway, created_at, profiles(full_name)').order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }
}
""", "")

with open('lib/features/admin/data/repositories/admin_repository.dart', 'w') as f:
    f.write(content)
