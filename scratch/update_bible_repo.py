import re

with open('lib/features/bible/data/repositories/bible_repository.dart', 'r') as f:
    content = f.read()

# Change getChapter network fetch to bolls.life
get_chapter_old = """    // 3. Fetch from Network
    try {
      final url = '$baseUrl/$vId/books/$bookSlug/chapters/$chapterNumber.json';
      final response = await _dio.get(url);
      
      final Map<String, dynamic> jsonMap = response.data is String 
          ? jsonDecode(response.data) 
          : (response.data as Map<String, dynamic>);
      
      // Save raw JSON to local cache for offline reading later
      _cacheBox!.put(cacheKey, jsonEncode(jsonMap));

      final chapter = BibleChapter.fromJsonWldeh(chapterNumber, jsonMap);
      _chapterMemoryCache[cacheKey] = chapter;
      return chapter;
    } catch (e) {"""

get_chapter_new = """    // 3. Fetch from Network
    try {
      final int bookIndex = _canonicalBooks.indexWhere((b) => b['id'] == bookId.toUpperCase()) + 1;
      final actualBookIndex = bookIndex > 0 ? bookIndex : 1;
      
      final url = 'https://bolls.life/get-chapter/$vId/$actualBookIndex/$chapterNumber/';
      
      // Use a new Dio without the base config since we are calling an external API
      final fetchDio = Dio();
      final response = await fetchDio.get(url);
      
      final List<dynamic> jsonList = response.data is String 
          ? jsonDecode(response.data) 
          : (response.data as List<dynamic>);
      
      // Save raw JSON to local cache for offline reading later
      _cacheBox!.put(cacheKey, jsonEncode(jsonList));

      final chapter = BibleChapter.fromJsonBolls(chapterNumber, jsonList);
      _chapterMemoryCache[cacheKey] = chapter;
      return chapter;
    } catch (e) {"""

content = content.replace(get_chapter_old, get_chapter_new)

# Also need to fix the fallback where it loads from cache (it loads as Map but now it could be List)
fallback_old = """    // 2. Check local persistence (Offline First capability)
    final cachedJsonStr = _cacheBox!.get(cacheKey);
    if (cachedJsonStr != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(cachedJsonStr);
        final chapter = BibleChapter.fromJsonWldeh(chapterNumber, jsonMap);
        _chapterMemoryCache[cacheKey] = chapter;
        return chapter;
      } catch (_) {
        // Fallback to fetch if local cache is corrupted
      }
    }"""

fallback_new = """    // 2. Check local persistence (Offline First capability)
    final cachedJsonStr = _cacheBox!.get(cacheKey);
    if (cachedJsonStr != null) {
      try {
        final dynamic decoded = jsonDecode(cachedJsonStr);
        BibleChapter chapter;
        if (decoded is List) {
          chapter = BibleChapter.fromJsonBolls(chapterNumber, decoded);
        } else {
          chapter = BibleChapter.fromJsonWldeh(chapterNumber, decoded as Map<String, dynamic>);
        }
        _chapterMemoryCache[cacheKey] = chapter;
        return chapter;
      } catch (_) {
        // Fallback to fetch if local cache is corrupted
      }
    }"""

content = content.replace(fallback_old, fallback_new)

with open('lib/features/bible/data/repositories/bible_repository.dart', 'w') as f:
    f.write(content)
print("Updated bible_repository.dart")
