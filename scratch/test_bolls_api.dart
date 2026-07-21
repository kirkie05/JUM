import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    // bolls get-chapter
    final url = 'https://bolls.life/get-chapter/KJV/1/2/';
    print('Fetching \$url');
    final response = await dio.get(url);
    print('Type of response data: \${response.data.runtimeType}');
    if (response.data is List) {
      final list = response.data as List;
      print('First item: \${list.first}');
    } else {
      print('Data: \${response.data}');
    }
  } catch (e) {
    print('Error: \$e');
  }
}
