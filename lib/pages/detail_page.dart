import 'package:material_ui/material_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final String animeId;
  const DetailPage({super.key, required this.animeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Anime> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchAnimeDetail(widget.animeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<Anime>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kAccent));
          }
          if (snap.hasError || !snap.hasData) {
            return Center(child: Text('Gagal memuat data\n${snap.error}'));
          }
          return _content(snap.data!);
        },
      ),
    );
  }

  Widget _content(Anime a) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image (hero)
          SizedBox(
            width: double.infinity,
            height: 200,
            child: a.cover == null
                ? const Icon(Icons.image_not_supported, size: 48)
                : Image.network(a.cover!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 48)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(a.rating ?? 'N/A'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${a.ageRating ?? 'N/A'} • ${a.episodeCount ?? 'N/A'} Episodes',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {}, // static
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Nonton'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol favorit: UI berubah sesuai status
                    ValueListenableBuilder(
                      valueListenable:
                          FavoriteService.box.listenable(keys: [a.id]),
                      builder: (context, box, _) {
                        final fav = FavoriteService.isFavorite(a.id);
                        return Material(
                          color: fav ? Colors.red.shade700 : Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => FavoriteService.toggle(a),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                fav ? Icons.favorite : Icons.favorite_border,
                                color: fav ? Colors.white : Colors.grey[300],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Overview',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  a.synopsis ?? 'Sinopsis tidak tersedia.',
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
