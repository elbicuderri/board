import 'package:flutter/material.dart';
import 'post_list_page.dart';

class PostPage extends StatefulWidget {
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
  State<PostPage> createState() => _PostPageState();
}

// Custom FloatingActionButtonLocation implementation
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetX; // Positive values move right, negative values move left
  final double offsetY; // Positive values move down, negative values move up

  CustomFloatingActionButtonLocation(this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Get the default position for the FloatingActionButton
    final double fabX = scaffoldGeometry.scaffoldSize.width / 2;
    final double fabY =
        scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        scaffoldGeometry.contentBottom -
        16.0; // Standard bottom margin

    // Return the adjusted position
    return Offset(fabX + offsetX, fabY + offsetY);
  }
}

class _PostPageState extends State<PostPage> {
  // ScrollController for controlling the scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                            widget.post.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            widget.post.category,
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
                    // Use fixed width for content to ensure scrollbar position
                    Expanded(
                      child: RawScrollbar(
                        controller: _scrollController,
                        thumbColor: Colors.red.shade600,
                        trackColor: Colors.grey.withValues(alpha: 0.1),
                        radius: Radius.circular(20),
                        thickness: 8,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width -
                                48, // Full width minus padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.content,
                                  style: TextStyle(fontSize: 16),
                                ),
                                // Add some extra space at the bottom to ensure scrollability on short content
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
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
          (widget.post.author == widget.loggedInId && widget.onDelete != null)
              ? FloatingActionButton.extended(
                onPressed: widget.onDelete,
                backgroundColor: Colors.red,
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Delete', style: TextStyle(color: Colors.white)),
              )
              : null,
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        MediaQuery.of(context).size.width *
            0.1, // Move right by 10% of screen width
        920, // Move down by 30 pixels
      ),
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
              'View Post',
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
