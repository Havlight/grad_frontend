import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountController = TextEditingController();

  Future<void> _register() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/create');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": _accountController.text,
        "password": _passwordController.text,
        "first_name": _firstnameController.text,
        "last_name": _lastnameController.text,
        "email": _emailController.text,
        "is_superuser": false,
        "is_staff": false
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final user = responseData['user'];
      final tokenExpDate = responseData['token_exp_date'];

      print('注册成功: $token');
      print('使用者訊息: $user');
      print('Token Expiration Date: $tokenExpDate');


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationController()),
      );

    } else {
      // 处理错误
      print('註冊失敗: ${response.statusCode}');
      print('response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: '姓氏'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: '名字'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'e-mail'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _accountController,
              decoration: InputDecoration(labelText: '帳號'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '密碼'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('註冊'),
            ),
          ],
        ),
      ),
    );
  }
}
