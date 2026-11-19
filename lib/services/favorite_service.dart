import 'package:hive_flutter/hive_flutter.dart';
import '../models/anime.dart';

/// Pengelolaan daftar favorit memakai Hive.
class FavoriteService {
  static const String boxName = 'favorites';

  static Box get box => Hive.box(boxName);

  static bool isFavorite(String id) => box.containsKey(id);

  static Future<void> add(Anime a) => box.put(a.id, {
        'id': a.id,
        'title': a.title,
        'poster': a.poster,
        'rating': a.rating,
      });

  static Future<void> remove(String id) => box.delete(id);

  static Future<void> toggle(Anime a) async {
    if (isFavorite(a.id)) {
      await remove(a.id);
    } else {
      await add(a);
    }
  }

  static int get count => box.length;
}
