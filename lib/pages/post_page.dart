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
    // Values for responsive design based on device size
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.06;
    final double verticalPadding = screenSize.height * 0.03;

    // Set min/max padding values
    final double minHorizontalPadding = 16.0;
    final double maxHorizontalPadding = 32.0;
    final double minVerticalPadding = 16.0;
    final double maxVerticalPadding = 32.0;

    // Limit padding values to the specified range
    final double safePaddingHorizontal = horizontalPadding.clamp(
      minHorizontalPadding,
      maxHorizontalPadding,
    );
    final double safePaddingVertical = verticalPadding.clamp(
      minVerticalPadding,
      maxVerticalPadding,
    );

    // Responsive font size settings
    final double titleFontSize = (screenSize.width * 0.05).clamp(18.0, 24.0);
    final double contentFontSize = (screenSize.width * 0.04).clamp(14.0, 18.0);
    final double categoryFontSize = (screenSize.width * 0.03).clamp(12.0, 16.0);

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            PostPageBar(),
            SizedBox(height: safePaddingVertical * 0.3),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: safePaddingHorizontal,
                  vertical: safePaddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap the title row in a SingleChildScrollView to handle overflow
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.post.category,
                            style: TextStyle(
                              fontSize: categoryFontSize,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              widget.post.title,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 14, thickness: 1, color: Colors.red),
                    SizedBox(height: safePaddingVertical * 0.6),
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  screenSize.width -
                                  (safePaddingHorizontal * 2),
                              minHeight: 100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: SelectableText(
                                    widget.post.content,
                                    style: TextStyle(fontSize: contentFontSize),
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
                                SizedBox(height: safePaddingVertical),
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
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (screenSize.width * 0.035).clamp(12.0, 16.0),
                  ),
                ),
              )
              : null,
      floatingActionButtonLocation: ResponsiveFloatingActionButtonLocation(
        screenSize: screenSize,
        widthRatio: 0.1,
        heightRatio: 0.1,
      ),
    );
  }
}

class PostPageBar extends StatelessWidget {
  const PostPageBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double titleFontSize = (screenSize.width * 0.05).clamp(16.0, 22.0);

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
              iconSize: (screenSize.width * 0.06).clamp(20.0, 28.0),
              padding: EdgeInsets.all(
                (screenSize.width * 0.02).clamp(8.0, 16.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'View Post',
              style: TextStyle(
                color: Colors.black,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FloatingActionButtonLocation that adjusts to device size
class ResponsiveFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  final Size screenSize;
  final double widthRatio; // Width ratio
  final double heightRatio; // Height ratio

  ResponsiveFloatingActionButtonLocation({
    required this.screenSize,
    this.widthRatio = 0.05, // Default value
    this.heightRatio = 0.1, // Default value
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Widen the clamp range to ensure ratio changes have a visible effect
    final double offsetX = (screenSize.width * widthRatio).clamp(10.0, 100.0);
    final double offsetY = (screenSize.height * heightRatio).clamp(20.0, 200.0);

    // print('offsetX: $offsetX, offsetY: $offsetY');
    // print('widthRatio: $widthRatio, heightRatio: $heightRatio');

    final double fabX =
        scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        offsetX;
    final double fabY = scaffoldGeometry.contentBottom - offsetY;

    return Offset(fabX, fabY);
  }
}
