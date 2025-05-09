import 'package:flutter/material.dart';
import 'write_page.dart';
import 'post_page.dart';

class Post {
  final String category;
  final String title;
  final String content;
  Post({required this.category, required this.title, required this.content});
}

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final List<Post> _posts = [];

  void _navigateToWritePage() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => WritePage(),
      ),
    );
    if (newPost != null) {
      setState(() {
        _posts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToWritePage,
          ),
        ],
      ),
      body: _posts.isEmpty
          ? Center(child: Text('등록된 글이 없습니다.'))
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          post.category,
                          style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _posts.removeAt(index);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostPage(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
