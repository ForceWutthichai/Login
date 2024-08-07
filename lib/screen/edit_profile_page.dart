import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final int userId;

  EditProfilePage({required this.profileData, required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = Map<String, dynamic>.from(widget.profileData);
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await http.put(
          Uri.parse('http://localhost:3000/profile/${widget.userId}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(_formData),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF2A6F97),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField('title_name', 'คำนำหน้า'),
                _buildTextFormField('first_name', 'ชื่อ'),
                _buildTextFormField('last_name', 'นามสกุล'),
                _buildTextFormField('id_card', 'เลขบัตรประชาชน'),
                _buildTextFormField('phone', 'เบอร์โทร'),
                _buildTextFormField('gender', 'เพศ'),
                _buildTextFormField('date_birth', 'วันเกิด'),
                _buildTextFormField('house_number', 'เลขบ้าน'),
                _buildTextFormField('street', 'ถนน'),
                _buildTextFormField('village', 'หมู่บ้าน'),
                _buildTextFormField('subdistrict', 'ตําบล'),
                _buildTextFormField('district', 'อําเภอ'),
                _buildTextFormField('province', 'จังหวัด'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Color(0xFF2A6F97),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: _formData[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onSaved: (value) {
          _formData[key] = value;
        },
      ),
    );
  }
}
