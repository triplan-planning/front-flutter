import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

const String baseUrl = "https://api-go-triplan.up.railway.app";

Future<List<T>> fetchAndDecodeList<T>(
    String path, List<T> Function(List<dynamic> json) deserializer) async {
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] GET $path");
  final response = await http.get(uri);
  log("[API] response status ${response.statusCode}");

  if (response.statusCode != 200) {
    throw Exception('Failed to load data from api endpoint $path');
  }

  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

  return deserializer(jsonResponse);
}

Future<T> fetchAndDecode<T>(
    String path, T Function(dynamic json) deserializer) async {
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] GET $path");
  final response = await http.get(uri);
  log("[API] response status ${response.statusCode}");

  if (response.statusCode != 200) {
    throw Exception('Failed to load data from api endpoint $path');
  }

  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

  return deserializer(jsonResponse);
}
