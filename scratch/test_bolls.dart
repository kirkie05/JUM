import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://bolls.life/get-chapter/KJV/1/1/');
    print(jsonEncode(response.data).substring(0, 500));
  } catch (e) {
    print(e);
  }
}
