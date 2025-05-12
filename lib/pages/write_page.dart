import 'package:flutter/material.dart';
import 'post_list_page.dart';

class WritePage extends StatefulWidget {
  final String author;
  const WritePage({super.key, required this.author});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // static const _greyColor = Color(0xFFE5E5E5);
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _discussionFocusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _discussionController = TextEditingController();

  String? _selectedCategory = '카테고리 선택';
  final List<String> _categories = ['자유', '공지'];

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _discussionFocusNode.dispose();
    _titleController.dispose();
    _discussionController.dispose();
    super.dispose();
  }

  void onCategoryTap() async {
    Widget createCategoryList() {
      return ListView(
        shrinkWrap: true,
        children:
            _categories.map((category) {
              return ListTile(
                title: Text(
                  category,
                  style: TextStyle(
                    color:
                        category == _selectedCategory
                            ? Colors.black
                            : Color(0xFF747779),
                    fontWeight:
                        category == _selectedCategory
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                trailing:
                    category == _selectedCategory
                        ? Icon(Icons.check, color: Colors.blue)
                        : null,
                onTap: () => Navigator.pop(context, category),
              );
            }).toList(),
      );
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return createCategoryList();
      },
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  bool get _canSubmit =>
      _selectedCategory != null &&
      _selectedCategory != '카테고리 선택' &&
      _titleController.text.trim().isNotEmpty &&
      _discussionController.text.trim().isNotEmpty;

  void _submit() {
    if (_canSubmit) {
      final post = Post(
        category: _selectedCategory!,
        title: _titleController.text.trim(),
        content: _discussionController.text.trim(),
        author: widget.author,
      );
      Navigator.pop(context, post);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 사용 가능한 화면 높이 계산
    final availableHeight =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kToolbarHeight -
        42; // 툴바 높이 + 여백

    // ContentField의 높이를 계산 (최대 화면의 45%로 제한)
    final contentHeight = availableHeight * 0.45;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            WritePageBar(canSubmit: _canSubmit, submit: _submit),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 18),
                      CategoryField(
                        onTap: onCategoryTap,
                        selectedCategory: _selectedCategory,
                        color: Colors.red,
                        borderRadius: 16,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 56,
                      ),
                      SizedBox(height: 12),
                      TitleField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        onChanged: (_) => setState(() {}),
                        color: Colors.red,
                        borderRadius: 16,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 56,
                      ),
                      SizedBox(height: 12),
                      ContentField(
                        controller: _discussionController,
                        focusNode: _discussionFocusNode,
                        onChanged: (_) => setState(() {}),
                        fillColor: Colors.yellow,
                        borderRadius: 16,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: contentHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WritePageBar extends StatelessWidget {
  final bool canSubmit;
  final VoidCallback submit;

  const WritePageBar({
    super.key,
    required this.canSubmit,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.yellow),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: BackButton()),
          Align(alignment: Alignment.center, child: Text('글쓰기')),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: canSubmit ? submit : null,
              child: Text(
                '등록',
                style: TextStyle(
                  color: canSubmit ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryField extends StatelessWidget {
  final VoidCallback onTap;
  final String? selectedCategory;
  final Color color;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CategoryField({
    super.key,
    required this.onTap,
    required this.selectedCategory,
    this.color = Colors.yellow,
    this.height = 56,
    this.borderRadius = 16,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: TextField(
          readOnly: true,
          onTap: onTap,
          enableInteractiveSelection: false,
          controller: TextEditingController(
            text: selectedCategory ?? '카테고리 선택',
          ),
          style: TextStyle(
            color:
                selectedCategory == '카테고리 선택'
                    ? Color(0xFF747779)
                    : Colors.black,
            fontWeight:
                selectedCategory == '카테고리 선택'
                    ? FontWeight.normal
                    : FontWeight.bold,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: '카테고리 선택',
            hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
            filled: true,
            fillColor: color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            contentPadding: EdgeInsets.all(12),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF747779),
            ),
          ),
          showCursor: false,
        ),
      ),
    );
  }
}

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double height;

  const TitleField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.color = Colors.yellow,
    this.borderRadius = 8,
    this.padding = EdgeInsets.zero,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enableInteractiveSelection: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 16,
            fontWeight:
                focusNode.hasFocus ? FontWeight.bold : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: '제목',
            hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
            filled: true,
            fillColor: color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
          onChanged: onChanged,
          contextMenuBuilder: (context, editableTextState) {
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
        ),
      ),
    );
  }
}

class ContentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final Color fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double height;

  const ContentField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.fillColor = Colors.yellow,
    this.borderRadius = 8,
    this.padding,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: height,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: null,
          expands: true,
          enableInteractiveSelection: true,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(
            color: Color(0xFF000000),
            fontWeight:
                focusNode.hasFocus ? FontWeight.bold : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: '내용을 입력하세요',
            hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
          contextMenuBuilder: (context, editableTextState) {
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
        ),
      ),
    );
  }
}
