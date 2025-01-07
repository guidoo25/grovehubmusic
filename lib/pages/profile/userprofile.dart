import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class UserProfileScreen extends StatefulWidget {
  final String artistId;

  const UserProfileScreen({Key? key, required this.artistId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _userSongs = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.post(
        Uri.parse('${Enviroments.apiUrl}/user/songs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': widget.artistId,
          'status': 'published',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _userData = data['data']['user'];
            _userSongs = List<Map<String, dynamic>>.from(data['data']['songs']);
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load user data');
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orange))
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: TextStyle(color: Colors.red)))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(_userData?['username'] ?? 'Unknown User'),
                        background: _userData?['banner_url'] != null
                            ? Image.network(
                                _userData!['banner_url'],
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.grey[800]),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _userData?['avatar_url'] !=
                                          null
                                      ? NetworkImage(_userData!['avatar_url'])
                                      : null,
                                  child: _userData?['avatar_url'] == null
                                      ? Icon(Icons.person, size: 50)
                                      : null,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userData?['full_name'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (_userData?['verified_artist'] == 2)
                                        Text(
                                          'Pro Artist',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      SizedBox(height: 4),
                                      Text(
                                        _userData?['role'] ?? 'Unknown Role',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              _userData?['bio'] ?? 'No bio available',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  Icons.music_note,
                                  '${_userSongs.length}',
                                  'Songs',
                                ),
                                // _buildStatItem(
                                //   Icons.play_circle_filled,
                                //   '${_userSongs.fold(0, (sum, song) => sum + (song['plays_count'] ?? 0))}',
                                //   'Plays',
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final song = _userSongs[index];
                          return _buildSongItem(song);
                        },
                        childCount: _userSongs.length,
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSongItem(Map<String, dynamic> song) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: NetworkImage(
                    '${Enviroments.imageurl}/${song['cover_art_url']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'] ?? 'Untitled',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${song['plays_count']} plays · ${song['genre'] ?? 'Unknown Genre'}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled, color: Colors.orange),
            onPressed: () {
              // Implement play functionality
              GoRouter.of(context).go('/song/${song['title']}', extra: song);
            },
          ),
        ],
      ),
    );
  }
}
