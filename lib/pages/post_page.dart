import 'package:flutter/material.dart';
import 'post_list_page.dart';

// 반응형 UI를 위한 도우미 클래스
class PostPageResponsiveUI {
  final BuildContext context;
  final Size screenSize;

  PostPageResponsiveUI(this.context) : screenSize = MediaQuery.of(context).size;

  // 패딩 계산 메서드
  double get horizontalPadding => (screenSize.width * 0.06).clamp(16.0, 32.0);
  double get verticalPadding => (screenSize.height * 0.03).clamp(16.0, 32.0);

  // 폰트 크기 계산 메서드
  double get titleFontSize => (screenSize.width * 0.05).clamp(18.0, 24.0);
  double get contentFontSize => (screenSize.width * 0.04).clamp(14.0, 18.0);
  double get categoryFontSize => (screenSize.width * 0.03).clamp(12.0, 16.0);
  double get buttonFontSize => (screenSize.width * 0.035).clamp(12.0, 16.0);

  // UI 요소 크기 계산 메서드
  double get deleteButtonHeight => (screenSize.height * 0.07).clamp(50.0, 70.0);
  double get contentMinHeight => (screenSize.height * 0.15).clamp(100.0, 200.0);
  double get dividerSpacing => verticalPadding * 0.6;
  double get headerIconSize => (screenSize.width * 0.06).clamp(20.0, 28.0);
  double get headerIconPadding => (screenSize.width * 0.02).clamp(8.0, 16.0);

  // FAB 위치 계산을 위한 비율
  double get fabWidthRatio => 0.1;
  double get fabHeightRatio => 0.1;
}

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
    // 반응형 UI 설정
    final PostPageResponsiveUI responsive = PostPageResponsiveUI(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            PostPageBar(responsive: responsive),
            SizedBox(height: responsive.verticalPadding * 0.3),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.horizontalPadding,
                  vertical: responsive.verticalPadding,
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
                              fontSize: responsive.categoryFontSize,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              widget.post.title,
                              style: TextStyle(
                                fontSize: responsive.titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 14, thickness: 1, color: Colors.red),
                    SizedBox(height: responsive.dividerSpacing),
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
                                  responsive.screenSize.width -
                                  (responsive.horizontalPadding * 2),
                              minHeight: responsive.contentMinHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: SelectableText(
                                    widget.post.content,
                                    style: TextStyle(
                                      fontSize: responsive.contentFontSize,
                                      height: 1.5,
                                    ),
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
                                SizedBox(height: responsive.verticalPadding),
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
              ? SizedBox(
                height: responsive.deleteButtonHeight,
                child: FloatingActionButton.extended(
                  onPressed: widget.onDelete,
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.buttonFontSize,
                    ),
                  ),
                ),
              )
              : null,
      floatingActionButtonLocation: ResponsiveFloatingActionButtonLocation(
        screenSize: responsive.screenSize,
        widthRatio: responsive.fabWidthRatio,
        heightRatio: responsive.fabHeightRatio,
      ),
    );
  }
}

class PostPageBar extends StatelessWidget {
  final PostPageResponsiveUI responsive;

  const PostPageBar({super.key, required this.responsive});

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
              iconSize: responsive.headerIconSize,
              padding: EdgeInsets.all(responsive.headerIconPadding),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'View Post',
              style: TextStyle(
                color: Colors.black,
                fontSize: responsive.titleFontSize,
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

    final double fabX =
        scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        offsetX;
    final double fabY = scaffoldGeometry.contentBottom - offsetY;

    return Offset(fabX, fabY);
  }
}
