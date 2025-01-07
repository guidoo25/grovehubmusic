import 'package:flutter/material.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaHotPicks extends StatefulWidget {
  const PantallaHotPicks({Key? key}) : super(key: key);

  @override
  _PantallaHotPicksState createState() => _PantallaHotPicksState();
}

class _PantallaHotPicksState extends State<PantallaHotPicks> {
  List<Song> _songs = [];
  bool _isLoading = false;
  String _error = '';

  // Filter states
  String? _selectedGenre;
  String _sortBy = 'created_at';
  String _sortOrder = 'DESC';

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(Uri.parse(
          '${Enviroments.apiUrl}/songs/filter?genre=$_selectedGenre&sort_by=$_sortBy&sort_order=$_sortOrder'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _songs = (data['data'] as List)
                .map((item) => Song.fromJson(item))
                .toList();
          });
        } else {
          setState(() {
            _error = 'Failed to load songs';
          });
        }
      } else {
        setState(() {
          _error = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF181818),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hot Picks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildFilterButton('Genre', _selectedGenre ?? 'All'),
                  const SizedBox(width: 8),
                  _buildSortButton(),
                ],
              ),
            ],
          ),
        ),
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_error.isNotEmpty)
          Text(_error, style: const TextStyle(color: Colors.red))
        else
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return _buildSongCard(song);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFilterButton(String label, String value) {
    return OutlinedButton(
      onPressed: () => _showGenreFilter(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        children: [
          Text('$label: $value'),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return OutlinedButton(
      onPressed: () => _showSortOptions(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        children: [
          Text('Sort: $_sortBy ${_sortOrder == 'ASC' ? '↑' : '↓'}'),
          const SizedBox(width: 4),
          const Icon(Icons.sort, size: 20),
        ],
      ),
    );
  }

  Widget _buildSongCard(Song song) {
    return Card(
      color: const Color(0xFF282828),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: song.coverArtUrl != null
            ? Image.network(song.coverArtUrl!,
                width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.music_note, size: 50, color: Colors.white),
        title: Text(song.title ?? 'Unknown Title',
            style: const TextStyle(color: Colors.white)),
        subtitle: Text(song.artistName ?? 'Unknown Artist',
            style: TextStyle(color: Colors.grey[400])),
        trailing: Text(song.genre ?? 'Unknown Genre',
            style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  void _showGenreFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Genre'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildGenreOption('All'),
                _buildGenreOption('Rock'),
                _buildGenreOption('Pop'),
                _buildGenreOption('Hip Hop'),
                _buildGenreOption('Electronic'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenreOption(String genre) {
    return ListTile(
      title: Text(genre),
      onTap: () {
        setState(() {
          _selectedGenre = genre == 'All' ? null : genre;
        });
        Navigator.of(context).pop();
        _fetchSongs();
      },
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sort By'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildSortOption('created_at', 'Date Added'),
                _buildSortOption('title', 'Title'),
                _buildSortOption('artist_name', 'Artist'),
                _buildSortOption('price', 'Price'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String sortBy, String label) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_upward,
                color: _sortBy == sortBy && _sortOrder == 'ASC'
                    ? Colors.blue
                    : null),
            onPressed: () {
              setState(() {
                _sortBy = sortBy;
                _sortOrder = 'ASC';
              });
              Navigator.of(context).pop();
              _fetchSongs();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_downward,
                color: _sortBy == sortBy && _sortOrder == 'DESC'
                    ? Colors.blue
                    : null),
            onPressed: () {
              setState(() {
                _sortBy = sortBy;
                _sortOrder = 'DESC';
              });
              Navigator.of(context).pop();
              _fetchSongs();
            },
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
