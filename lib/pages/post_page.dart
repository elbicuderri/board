import 'package:flutter/material.dart';
import 'post_list_page.dart';

class PostPage extends StatelessWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 보기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    post.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  post.category,
                  style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 32, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  post.content,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
