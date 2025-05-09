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
    _titleController.dispose();
    _discussionController.dispose();
    _titleFocusNode.dispose();
    _discussionFocusNode.dispose();
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
      _titleController.text.trim().isNotEmpty &&
      _discussionController.text.trim().isNotEmpty &&
      _selectedCategory != null &&
      _selectedCategory != '카테고리 선택';

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WritePageBar(canSubmit: _canSubmit, submit: _submit),
            SizedBox(height: 18),
            CategoryField(
              onTap: onCategoryTap,
              selectedCategory: _selectedCategory,
              color: Colors.red,
              height: 56,
              borderRadius: 16,
              padding: EdgeInsets.symmetric(horizontal: 16),
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
              height: 580,
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
                  color: canSubmit ? Colors.blue : Colors.green,
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
  final EdgeInsetsGeometry? padding;

  const CategoryField({
    super.key,
    required this.onTap,
    required this.selectedCategory,
    this.color = Colors.yellow,
    this.height = 56,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: height,
        child: TextField(
          readOnly: true,
          onTap: onTap,
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
          enableInteractiveSelection: false,
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
  final EdgeInsetsGeometry? padding;
  final double height;

  const TitleField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.color = Colors.yellow,
    this.borderRadius = 8,
    this.padding,
    this.height = 56,
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
          onChanged: onChanged,
        ),
      ),
    );
  }
}
