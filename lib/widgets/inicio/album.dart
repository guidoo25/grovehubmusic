import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:grovehubmusic/widgets/player/player.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class AlbumGrid extends StatefulWidget {
  const AlbumGrid({super.key});

  @override
  _AlbumGridState createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    try {
      final songs = await getSongs();
      setState(() {
        _songs = songs.items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching songs: $e');
    }
  }

  void _openSongPlayer(BuildContext context, Song song) {
    context.go('/song/${song.title}', extra: song);
  }

  void _openProfile(BuildContext context, Song song) {
    context.go('/user/${song.artistId}', extra: song.artistId);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return _buildSongCard(context, song);
      },
    );
  }

  Widget _buildSongCard(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () => _openSongPlayer(context, song),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color(0xFF111111), // Darker background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'song-cover-${song.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: '${Enviroments.imageurl}/${song.coverArtUrl}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Color(0xFF1E1E1E), // Darker placeholder color
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color:
                            Color(0xFF1E1E1E), // Darker error background color
                        child: Icon(Icons.error,
                            color: const Color.fromARGB(137, 0, 0, 0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title ?? 'Unknown Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(238, 14, 182, 0.102),
                        child: Text(
                          song.username != null && song.username!.isNotEmpty
                              ? song.username![0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        radius: 12,
                      ),
                      // if (song.verifiedArtist == 2)
                      //   Padding(
                      //     padding: const EdgeInsets.only(left: 4.0),
                      //     child:
                      //         Lottie.asset('pro.json', width: 24, height: 24),
                      //   ),
                      if (song.verifiedArtist == 2)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          song.username ?? 'Unknown Artist',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline,
                          size: 16, color: Colors.white54),
                      SizedBox(width: 4),
                      Text(
                        '${song.playsCount} vistas',
                        style: TextStyle(
                          color: Color.fromARGB(136, 238, 231, 231),
                          fontSize: 12,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                        icon: Icon(Icons.more_vert, color: Colors.white54),
                        items: [
                          DropdownMenuItem(
                            value: 'play',
                            child: Text('Reproducir'),
                          ),
                          DropdownMenuItem(
                            value: 'perfil',
                            child: Text('Ver perfil'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == 'play') {
                            _openSongPlayer(context, song);
                          } else if (value == 'perfil') {
                            _openProfile(context, song);
                          }
                        },
                      ))
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

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 5;
    if (screenWidth > 600) return 4;
    if (screenWidth > 400) return 3;
    return 2;
  }
}

// Keep the getSongs function as it is

Future<PaginatedResponse<Song>> getSongs({
  int page = 1,
  int perPage = 10,
  Map<String, dynamic>? filters,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  final queryParams = {
    'page': page.toString(),
    'per_page': perPage.toString(),
    ...?filters,
  };

  final uri = Uri.parse('${Enviroments.apiUrl}/songs')
      .replace(queryParameters: queryParams);

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      return PaginatedResponse.fromJson(
        jsonResponse,
        (json) => Song.fromJson(json),
      );
    } else {
      throw Exception('Failed to load songs');
    }
  } else {
    throw Exception('Failed to load songs');
  }
}
