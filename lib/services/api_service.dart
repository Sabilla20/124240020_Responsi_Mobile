import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class ApiService {
  static const String _base = 'https://kitsu.io/api/edge/anime';
  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.api+json',
  };

  /// Daftar semua anime (dengan paging).
  static Future<List<Anime>> fetchAnimeList(
      {int offset = 0, int limit = 20}) async {
    final uri = Uri.parse('$_base/?page[limit]=$limit&page[offset]=$offset');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat daftar anime (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'] as List;
    return data.map((e) => Anime.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Detail anime berdasarkan id.
  static Future<Anime> fetchAnimeDetail(String id) async {
    final res = await http.get(Uri.parse('$_base/$id'), headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail anime (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return Anime.fromJson(body['data'] as Map<String, dynamic>);
  }
}
