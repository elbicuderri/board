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
  String? _error;
  Map<String, dynamic>? _userData;

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

  void _login() {
    if (_userData == null) return;
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    if (id == _userData!["id"] && pw == _userData!["password"]) {
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('로그인', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_error != null) ...[
                SizedBox(height: 16),
                Text(_error!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _userData == null ? null : _login,
                  child: Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
