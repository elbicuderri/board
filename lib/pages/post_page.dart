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
                    // Wrap the title row in a SingleChildScrollView to handle overflow
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              widget.post.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 14, thickness: 1, color: Colors.red),
                    SizedBox(height: 18),
                    // Use fixed width for content to ensure scrollbar position
                    Expanded(
                      child: RawScrollbar(
                        controller: _scrollController,
                        thumbColor: Colors.red.withValues(alpha: 0.3),
                        trackColor: Colors.grey.withValues(alpha: 0.1),
                        radius: Radius.circular(20),
                        thickness: 4,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: SelectableText(
                                    widget.post.content,
                                    style: TextStyle(fontSize: 16),
                                    enableInteractiveSelection: true,
                                    contextMenuBuilder: (
                                      context,
                                      editableTextState,
                                    ) {
                                      return AdaptiveTextSelectionToolbar.editableText(
                                        editableTextState: editableTextState,
                                      );
                                    },
                                  ),
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
        offsetX: 20,
        offsetY: 20,
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

// CustomFloatingActionButtonLocation 수정
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  CustomFloatingActionButtonLocation({
    required this.offsetX,
    required this.offsetY,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - 
                       scaffoldGeometry.floatingActionButtonSize.width - 
                       offsetX;
    final double fabY = scaffoldGeometry.contentBottom - offsetY;
    
    return Offset(fabX, fabY);
  }
}
