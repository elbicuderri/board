import 'package:flutter/material.dart';
import 'write_page.dart';
import 'post_page.dart';
import 'login_page.dart';

class Post {
  final String category;
  final String title;
  final String content;
  final String author;
  Post({
    required this.category,
    required this.title,
    required this.content,
    required this.author,
  });
}

class PostListPage extends StatefulWidget {
  final String loggedInId;
  const PostListPage({super.key, required this.loggedInId});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final List<Post> _posts = [];

  void _navigateToWritePage() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (context) => WritePage(author: widget.loggedInId),
      ),
    );
    if (newPost != null) {
      setState(() {
        _posts.insert(0, newPost);
      });
    }
  }

  Widget buildPostList() {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostCard(
          post: post,
          color: Colors.yellow,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PostPage(
                      post: post,
                      loggedInId: widget.loggedInId,
                      onDelete: () {
                        setState(() {
                          _posts.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                    ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            PostListPageBar(onAdd: _navigateToWritePage),
            SizedBox(height: 10),
            Expanded(
              child:
                  _posts.isEmpty
                      ? Center(child: Text('등록된 글이 없습니다.'))
                      : buildPostList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '로그아웃',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        backgroundColor: Colors.red,
        child: Text('logout'),
      ),
    );
  }
}

class PostListPageBar extends StatelessWidget {
  final VoidCallback onAdd;
  const PostListPageBar({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Colors.yellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              '게시판',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends Card {
  PostCard({
    super.key,
    required Post post,
    required VoidCallback onTap,
    required EdgeInsetsGeometry super.margin,
    required Color super.color,
  }) : super(
         child: ListTile(
           title: Row(
             children: [
               Text(
                 post.category,
                 style: TextStyle(color: Colors.blueGrey, fontSize: 12),
               ),
               SizedBox(width: 8),
               Expanded(
                 child: Text(
                   post.title,
                   style: TextStyle(fontWeight: FontWeight.bold),
                 ),
               ),
             ],
           ),
           onTap: onTap,
         ),
       );
}
