import 'package:get/get.dart';
import '../models/anime.dart';
import '../services/favorite_service.dart';

/// GetX controller untuk state jumlah & isi favorit.
class FavoriteController extends GetxController {
  /// Jumlah anime yang difavoritkan — reactive (RxInt).
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Sinkronisasi awal dengan data Hive yang sudah ada.
    count.value = FavoriteService.count;
  }

  /// Toggle favorit dan perbarui [count] secara reaktif.
  Future<void> toggle(Anime a) async {
    await FavoriteService.toggle(a);
    count.value = FavoriteService.count;
  }

  /// Cek apakah anime sudah difavoritkan.
  bool isFavorite(String id) => FavoriteService.isFavorite(id);
}
