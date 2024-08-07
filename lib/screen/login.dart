import 'package:auto_route/auto_route.dart';
import 'package:final_login/constants/color.dart';
import 'package:final_login/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@RoutePage()
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id_card': _idCardController.text.replaceAll('-', ''), // Remove dashes before sending
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        int userId = int.parse(userData['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid ID Card or Password')),
        );
      }
    }
  }

  String? _validateIdCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสบัตรประชาชน';
    }

    final idCardRegex = RegExp(r'^\d{1}-\d{4}-\d{5}-\d{2}-\d{1}$');
    if (!idCardRegex.hasMatch(value)) {
      return 'รหัสบัตรประชาชนไม่ถูกต้อง';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }

    // Add any additional password requirements here
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }

    return null;
  }

  void _formatIdCard() {
    String text = _idCardController.text.replaceAll('-', '');
    if (text.length > 1) {
      text = text.substring(0, 1) + '-' + text.substring(1);
    }
    if (text.length > 6) {
      text = text.substring(0, 6) + '-' + text.substring(6);
    }
    if (text.length > 12) {
      text = text.substring(0, 12) + '-' + text.substring(12);
    }
    if (text.length > 15) {
      text = text.substring(0, 15) + '-' + text.substring(15);
    }
    _idCardController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 230,
                        maxHeight: 230,
                      ),
                      child: Image.asset('assets/image/logor.png',
                          fit: BoxFit.fill),
                    ),
                    SizedBox(height: 30),
                    const Text('เข้าสู่ระบบ',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: grayText)),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _idCardController,
                      decoration: const InputDecoration(
                        labelText: 'รหัสบัตรประชาชน',
                        labelStyle: TextStyle(color: textMainColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: borderColor, width: 1),
                        ),
                      ),
                      validator: _validateIdCard,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formatIdCard();
                      },
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        labelStyle: TextStyle(color: textMainColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: borderColor, width: 1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleVisibility,
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: borderColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('ยังไม่มีสมาชิก?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: grayText)),
                      TextButton(
                        onPressed: () {
                          context.router.pushNamed('/register_page1');
                        },
                        child: Text('คลิกที่นี่',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textMainColor)),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
