import 'package:material_ui/material_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder(
        valueListenable: FavoriteService.box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada anime favorit'));
          }
          final items = box.values.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final m = Map<String, dynamic>.from(items[i] as Map);
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(animeId: m['id'])),
                  ),
                  leading: m['poster'] == null
                      ? const Icon(Icons.image_not_supported)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(m['poster'],
                              width: 40,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image)),
                        ),
                  title: Text(m['title'] ?? '-',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(m['rating'] ?? 'N/A'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => FavoriteService.remove(m['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
