import 'package:flutter/material.dart';
import 'post_list_page.dart';

class WritePage extends StatefulWidget {
  final String author;
  const WritePage({super.key, required this.author});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  static const _greyColor = Color(0xFFE5E5E5);
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
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
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
      appBar: AppBar(
        leading: BackButton(),
        title: Text('글쓰기'),
        actions: [
          TextButton(
            onPressed: _canSubmit ? _submit : null,
            child: Text(
              '등록',
              style: TextStyle(
                color: _canSubmit ? Colors.blue : _greyColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: onCategoryTap,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory ?? '카테고리 선택',
                        style: TextStyle(
                          color:
                              _selectedCategory == '카테고리 선택'
                                  ? Color(0xFF747779)
                                  : Colors.black,
                          fontWeight:
                              _selectedCategory == '카테고리 선택'
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF747779)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontWeight:
                      _titleFocusNode.hasFocus
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
                decoration: InputDecoration(
                  hintText: '제목',
                  hintStyle: TextStyle(color: Color(0xFF747779), fontSize: 16),
                  filled: true,
                  fillColor: Colors.yellow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _discussionController,
                  focusNode: _discussionFocusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight:
                        _discussionFocusNode.hasFocus
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: '내용을 입력하세요',
                    hintStyle: TextStyle(
                      color: Color(0xFF747779),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.yellow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
