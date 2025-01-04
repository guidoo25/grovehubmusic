import 'package:flutter/material.dart';
import 'package:grovehubmusic/services/forum-services.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final ForumService _forumService = ForumService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _comments = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadComments({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _comments = [];
        _hasMoreComments = true;
      });
    }

    if (_isLoading || !_hasMoreComments) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _forumService.getComments(widget.post['id'],
          page: _currentPage);
      final newComments = response['data'] as List<dynamic>;
      setState(() {
        _comments.addAll(newComments);
        _currentPage++;
        _isLoading = false;
        _hasMoreComments =
            newComments.length == 10; // Assuming 10 is the limit per page
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments: $e')),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadComments();
    }
  }

  Future<void> _createComment() async {
    if (_commentController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _forumService.createComment(
          widget.post['id'], _commentController.text);
      _commentController.clear();
      await _loadComments(refresh: true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fallo generar comentario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Comentarios', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _comments.length + (_hasMoreComments ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _comments.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final comment = _comments[index];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: comment['avatar_url'] != null
                                  ? NetworkImage(comment['avatar_url'])
                                  : null,
                              child: comment['avatar_url'] == null
                                  ? Text(comment['username'][0].toUpperCase())
                                  : null,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['username'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    timeago.format(
                                        DateTime.parse(comment['created_at'])),
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.favorite_border,
                            //       color: Colors.white),
                            //   onPressed: () {
                            //     // Implement like functionality
                            //   },
                            // ),
                            Text(
                              '${comment['likes_count']}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          comment['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Añadir comentario...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      fillColor: Colors.grey[800],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: _createComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
