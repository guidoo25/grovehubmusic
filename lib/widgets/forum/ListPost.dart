import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/pages/foro/cooments.dart';
import 'package:grovehubmusic/services/forum-services.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostListItem extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostListItem({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          post['title'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              post['content'],
              style: TextStyle(color: Colors.grey[300]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post['avatar_url'] != null
                      ? NetworkImage(post['avatar_url'])
                      : null,
                  child: post['avatar_url'] == null
                      ? Text(post['username'][0].toUpperCase())
                      : null,
                ),
                SizedBox(width: 8),
                Text(
                  post['username'],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).go('/admin/user/${post['user_id']}');
                  },
                  child: Text(
                    post['username'],
                    style: TextStyle(
                        color: Colors.grey[400],
                        decoration: TextDecoration.underline),
                  ),
                ),
                Spacer(),
                Text(
                  timeago.format(DateTime.parse(post['created_at'])),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonHideUnderline(
                child: DropdownButton(
              items: [
                DropdownMenuItem(
                  value: 'borrar',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 8),
                      Text('borrar post',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'edit') {
                  // Handle edit action
                } else if (value == 'delete') {
                  ForumService().inactivePost(post['id']);
                }
              },
            )),
            IconButton(
              icon: Icon(Icons.thumb_up, color: Colors.white),
              onPressed: onLike,
            ),
            Text(
              '${post['likes_count']}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.comment, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(post: post),
                  ),
                );
              },
            ),
            Text(
              '${post['comments_count']}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
