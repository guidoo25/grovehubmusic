import 'package:flutter/material.dart';
import 'package:grovehubmusic/services/forum-services.dart';
import 'package:grovehubmusic/widgets/forum/ListPost.dart';
import 'package:grovehubmusic/widgets/forum/postdialog.dart';

class ForumScreen extends StatefulWidget {
  final String topicId;
  const ForumScreen({super.key, required this.topicId});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumService _forumService = ForumService();
  List<dynamic> _posts = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _posts = [];
      });
    }

    if (_isLoading || _currentPage > _totalPages) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _forumService.getPosts(
          page: _currentPage, topicId: widget.topicId);
      setState(() {
        _posts.addAll(response['data']['posts']);
        _totalPages = response['data']['total_pages'];

        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $e')),
      );
    }
  }

  Future<void> _createPost(String title, String content) async {
    try {
      await _forumService.createPost(content);
      _loadPosts(refresh: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Foro', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadPosts(refresh: true),
        child: ListView.builder(
          itemCount: _posts.length + (_currentPage <= _totalPages ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _posts.length) {
              if (!_isLoading) {
                _loadPosts();
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final post = _posts[index];
            return PostListItem(
              post: post,
              onLike: () async {
                await _forumService.createLike(post['id']);
                _loadPosts(refresh: true);
              },
              onComment: () {
                // This is now handled in the PostListItem widget
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, String>>(
            context: context,
            builder: (context) => CreatePostDialog(),
          );
          if (result != null &&
              result['title']!.isNotEmpty &&
              result['content']!.isNotEmpty) {
            _createPost(result['title']!, result['content']!);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
