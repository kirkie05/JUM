import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://bolls.life/static/bolls/app/views/languages.json');
    final List<dynamic> langs = response.data;
    final english = langs.firstWhere((element) => element['language'].toString().toLowerCase().contains('english'), orElse: () => null);
    if (english != null) {
      final List<dynamic> translations = english['translations'];
      for (var t in translations) {
        print('${t['short_name']} - ${t['full_name']}');
      }
    } else {
      print('English not found');
    }
  } catch (e) {
    print(e);
  }
}
