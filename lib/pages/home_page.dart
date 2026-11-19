import 'package:flutter/material.dart';
import '../main.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  final List<Anime> _animes = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ApiService.fetchAnimeList(offset: 0);
      if (!mounted) return;
      setState(() {
        _animes
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _loading) return;
    setState(() => _loadingMore = true);
    try {
      final list = await ApiService.fetchAnimeList(offset: _animes.length);
      if (!mounted) return;
      setState(() => _animes.addAll(list));
    } catch (_) {}
    if (mounted) setState(() => _loadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.play_circle_outline, color: kAccent),
            SizedBox(width: 8),
            Text('Keripikroll',
                style: TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: kAccent));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemCount: _animes.length + (_loadingMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= _animes.length) {
          return const Center(child: CircularProgressIndicator(color: kAccent));
        }
        return _AnimeCard(anime: _animes[i]);
      },
    );
  }
}

class _AnimeCard extends StatelessWidget {
  final Anime anime;
  const _AnimeCard({required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(animeId: anime.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: anime.poster == null
                    ? const Icon(Icons.image_not_supported)
                    : Image.network(
                        anime.poster!,
                        fit: BoxFit.cover,
                        loadingBuilder: (c, child, p) => p == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(
                                    color: kAccent, strokeWidth: 2)),
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(anime.ageRating ?? 'N/A',
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(anime.rating ?? 'N/A',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
