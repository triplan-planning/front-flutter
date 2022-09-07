import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:triplan/src/utils/serialisable.dart';

const String baseUrl = "https://api-go-triplan.up.railway.app";

extension ResponseExtension on http.Response {
  bool get is2xx {
    return (statusCode ~/ 100) == 2;
  }

  String get decodedBody {
    return utf8.decode(bodyBytes);
  }
}

Future<List<T>> fetchAndDecodeList<T>(
    String path, List<T> Function(List<dynamic> json) deserializer) async {
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] GET $path");
  final response = await http.get(uri);
  log("[API] response status ${response.statusCode}");

  if (!response.is2xx) {
    throw Exception('Failed to load data from api endpoint $path');
  }

  if (response.decodedBody == "null") {
    return List.empty();
  }

  dynamic jsonResponse = jsonDecode(response.decodedBody);

  return deserializer(jsonResponse);
}

Future<T> fetchAndDecode<T>(
    String path, T Function(dynamic json) deserializer) async {
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] GET $path");
  final response = await http.get(uri);
  log("[API] response status ${response.statusCode}");

  if (!response.is2xx) {
    throw Exception('Failed to load data from api endpoint $path');
  }

  var jsonResponse = jsonDecode(response.decodedBody);

  return deserializer(jsonResponse);
}

Future<T> createNew<T extends Serializable>(String path, T entity,
    T Function(Map<String, dynamic> json) deserializer) async {
  String payload = jsonEncode(entity.toJson());
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] POST $path");
  final response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: payload,
  );
  log("[API] response status ${response.statusCode}");

  if (!response.is2xx) {
    log('Failed to create new entity: ${response.decodedBody}');
    throw Exception('Failed to create new Entity');
  }

  return deserializer(jsonDecode(response.decodedBody));
}

void deleteEntity(String path) async {
  Uri uri = Uri.parse(baseUrl + path);

  log("[API] DELETE $path");
  final response = await http.delete(uri);
  log("[API] response status ${response.statusCode}");

  if (!response.is2xx) {
    log('Failed to delete entity: ${response.decodedBody}');
    throw Exception('Failed to delete Entity');
  }
}
