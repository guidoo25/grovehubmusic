import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/services/forum-services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late Future<Map<String, dynamic>> _categoriesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allTopics = [];
  List<Map<String, dynamic>> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ForumService().fetchCategories();
    _searchController.addListener(_filterTopics);
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTopics = _allTopics
          .where(
              (topic) => topic['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.white)));
                    } else if (!snapshot.hasData ||
                        snapshot.data!['success'] != true) {
                      return Center(
                          child: Text('No topics found',
                              style: TextStyle(color: Colors.white)));
                    } else {
                      _allTopics = List<Map<String, dynamic>>.from(
                          snapshot.data!['data']);
                      _filteredTopics = _allTopics;
                      return _buildTopicGrid();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: Enviroments().getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          } else if (snapshot.hasError) {
            return SizedBox.shrink();
          } else if (snapshot.hasData &&
              (snapshot.data == 'moderator' || snapshot.data == 'admin')) {
            return FloatingActionButton(
              onPressed: () {
                // Implement create new topic functionality
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.orange,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Temas Foro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _categoriesFuture = ForumService().fetchCategories();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopicGrid() {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredTopics.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: MediaQuery.of(context).size.width ~/ 300,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTopicCard(_filteredTopics[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return GestureDetector(
      onTap: () {
        Enviroments().getRole().then((role) {
          if (role == 'admin') {
            GoRouter.of(context).go('/admin/foropost/${topic['id']}');
          } else {
            GoRouter.of(context).go('/foropost/${topic['id']}');
          }
        });
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.topic, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      topic['name'] ?? 'Untitled',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posts: ${topic['post_count'] ?? 0}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.white70, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
