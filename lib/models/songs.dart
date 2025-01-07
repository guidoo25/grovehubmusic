class Song {
  final String id;
  final String? albumId;
  final String artistId;
  final String? title;
  final String? genre;
  final String? description;
  final String? duration;
  final String filePath;
  final String coverArtUrl;
  final double? price;
  final String? lyrics;
  final int? trackNumber;
  final int playsCount;
  final int downloadsCount;
  final String status;
  final DateTime uploadDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? artistName;
  final String? genreName;
  final String? username;
  final String? bannerUrl;
  final int verifiedArtist;
  final String? avatarUrl;

  Song({
    required this.id,
    this.albumId,
    required this.artistId,
    this.title,
    this.genre,
    this.description,
    this.duration,
    required this.filePath,
    required this.coverArtUrl,
    this.price,
    this.lyrics,
    this.trackNumber,
    required this.playsCount,
    required this.downloadsCount,
    required this.status,
    required this.uploadDate,
    required this.createdAt,
    required this.updatedAt,
    this.artistName,
    this.genreName,
    this.username,
    this.bannerUrl,
    required this.verifiedArtist,
    this.avatarUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      albumId: json['album_id'],
      artistId: json['artist_id'],
      title: json['title'],
      genre: json['genre'],
      description: json['description'],
      duration: json['duration'],
      filePath: json['file_path'],
      coverArtUrl: json['cover_art_url'],
      price: json['price']?.toDouble(),
      lyrics: json['lyrics'],
      trackNumber: json['track_number'],
      playsCount: json['plays_count'] ?? 0,
      downloadsCount: json['downloads_count'] ?? 0,
      status: json['status'],
      uploadDate: DateTime.parse(json['upload_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      artistName: json['artist_name'],
      genreName: json['genre_name'],
      username: json['username'],
      bannerUrl: json['banner_url'],
      verifiedArtist: json['verified_artist'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int currentPage;
  final int perPage;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      items: (json['data']['songs'] as List)
          .map((item) => fromJson(item))
          .toList(),
      total: json['data']['total'],
      currentPage: json['data']['current_page'],
      perPage: json['data']['per_page'],
      totalPages: json['data']['total_pages'],
    );
  }
}
