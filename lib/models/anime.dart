class Anime {
  final String id;
  final String title;
  final String? poster;
  final String? cover;
  final String? ageRating;
  final String? rating;
  final String? synopsis;
  final int? episodeCount;

  Anime({
    required this.id,
    required this.title,
    this.poster,
    this.cover,
    this.ageRating,
    this.rating,
    this.synopsis,
    this.episodeCount,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final a = (json['attributes'] ?? {}) as Map<String, dynamic>;
    final titles = (a['titles'] ?? {}) as Map<String, dynamic>;
    final poster = a['posterImage'] as Map<String, dynamic>?;
    final cover = a['coverImage'] as Map<String, dynamic>?;

    return Anime(
      id: json['id'].toString(),
      title: (titles['en_jp'] ?? titles['en'] ?? a['canonicalTitle'] ?? '-')
          .toString(),
      poster: (poster?['small'] ?? poster?['tiny'] ?? poster?['original'])
          as String?,
      cover: (cover?['large'] ??
          cover?['small'] ??
          cover?['tiny'] ??
          poster?['large'] ??
          poster?['small']) as String?,
      ageRating: a['ageRating'] as String?,
      rating: a['averageRating'] as String?,
      synopsis: a['synopsis'] as String?,
      episodeCount: a['episodeCount'] as int?,
    );
  }
}
