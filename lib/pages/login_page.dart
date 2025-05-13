import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'post_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  String? _error;
  List<dynamic>? _userData;

  Future<void> _loadUserData() async {
    final String data = await rootBundle.loadString('lib/data/user_data.json');
    setState(() {
      _userData = json.decode(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }

  void _login() {
    if (_userData == null) return;
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    final found = _userData!.any(
      (user) => user["id"] == id && user["password"] == pw,
    );
    if (found) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostListPage(loggedInId: id)),
      );
    } else {
      setState(() {
        _error = '아이디 또는 비밀번호가 올바르지 않습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate padding as percentage of screen size
    final double horizontalPadding = screenSize.width * 0.07;
    final double verticalPadding = screenSize.height * 0.025;

    // Calculate UI element sizes as percentage of screen size
    final double titleSize = screenSize.width * 0.07;
    final double fieldSpacing = screenSize.height * 0.02;
    final double topSpacing = screenSize.height * 0.25;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    (verticalPadding * 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: topSpacing),
                  Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: titleSize.clamp(24.0, 32.0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: fieldSpacing * 1.5),
                  // Use the custom IdField widget instead of TextField
                  IdField(
                    controller: _idController,
                    focusNode: _idFocusNode,
                    screenSize: screenSize,
                  ),
                  SizedBox(height: fieldSpacing),
                  // Use the custom PasswordField widget
                  PasswordField(
                    controller: _pwController,
                    screenSize: screenSize,
                  ),
                  if (_error != null) ...[
                    SizedBox(height: fieldSpacing),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: (screenSize.width * 0.035).clamp(12.0, 16.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: fieldSpacing * 1.5),
                  // Use the custom LoginButton widget
                  LoginButton(
                    onPressed: _userData == null ? null : _login,
                    screenSize: screenSize,
                    text: 'login',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom reusable widget for ID input field
class IdField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Size screenSize;

  const IdField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: (screenSize.width * 0.04).clamp(14.0, 18.0),
        fontWeight: focusNode.hasFocus ? FontWeight.bold : FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelText: '아이디',
        labelStyle: TextStyle(
          color: Color(0xFF747779),
          fontSize: (screenSize.width * 0.035).clamp(12.0, 16.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015,
          horizontal: screenSize.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (screenSize.width * 0.02).clamp(8.0, 16.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (screenSize.width * 0.02).clamp(8.0, 16.0),
          ),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}

// Custom reusable widget for password input field
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final Size screenSize;

  const PasswordField({
    super.key,
    required this.controller,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(fontSize: (screenSize.width * 0.04).clamp(14.0, 18.0)),
      decoration: InputDecoration(
        labelText: '비밀번호',
        labelStyle: TextStyle(
          color: Color(0xFF747779),
          fontSize: (screenSize.width * 0.035).clamp(12.0, 16.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015,
          horizontal: screenSize.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (screenSize.width * 0.02).clamp(8.0, 16.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            (screenSize.width * 0.02).clamp(8.0, 16.0),
          ),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}

// Custom reusable widget for login button
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Size screenSize;
  final String text;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.screenSize,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = screenSize.width * 0.35;
    final double buttonHeight = screenSize.height * 0.055;
    final double buttonRadius = screenSize.width * 0.08;

    return SizedBox(
      width: buttonWidth.clamp(120.0, 180.0),
      height: buttonHeight.clamp(40.0, 56.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          side: BorderSide(
            color: Colors.green,
            width: (screenSize.width * 0.005).clamp(1.5, 3.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius.clamp(20.0, 40.0)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: (screenSize.width * 0.04).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
