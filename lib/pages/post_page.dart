import 'package:flutter/material.dart';
import 'post_list_page.dart';

class PostPage extends StatelessWidget {
  final Post post;
  final String loggedInId;
  final VoidCallback? onDelete;

  const PostPage({
    super.key,
    required this.post,
    required this.loggedInId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            PostPageBar(),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            post.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 14, thickness: 1, color: Colors.red),
                    SizedBox(height: 18),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          (post.author == loggedInId && onDelete != null)
              ? FloatingActionButton.extended(
                onPressed: onDelete,
                backgroundColor: Colors.red,
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('삭제', style: TextStyle(color: Colors.white)),
              )
              : null,
    );
  }
}

class PostPageBar extends StatelessWidget {
  const PostPageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.yellow),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '게시글 보기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // If you need an action on the right, uncomment the code below.
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     icon: Icon(Icons.more_vert, color: Colors.white),
          //     onPressed: () {},
          //   ),
          // ),
        ],
      ),
    );
  }
}
