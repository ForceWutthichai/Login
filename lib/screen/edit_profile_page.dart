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
  late String selectedTitle;
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    _formData = Map<String, dynamic>.from(widget.profileData);
    selectedTitle = _formData['title_name'];
    selectedGender = _formData['gender'];
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
          Navigator.pop(context, _formData);
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
                DropdownButtonFormField<String>(
                  value: selectedTitle,
                  items: ['นาย', 'นาง', 'นางสาว'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value!;
                      _formData['title_name'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'คำนำหน้า',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onSaved: (value) {
                    _formData['title_name'] = value;
                  },
                ),
                SizedBox(height: 8.0),
                _buildTextFormField('first_name', 'ชื่อ'),
                _buildTextFormField('last_name', 'นามสกุล'),
                _buildTextFormField('id_card', 'เลขบัตรประชาชน'),
                _buildTextFormField('phone', 'เบอร์โทร'),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: ['ชาย', 'หญิง', 'อื่นๆ'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                      _formData['gender'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'เพศ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onSaved: (value) {
                    _formData['gender'] = value;
                  },
                ),
                _buildTextFormField('date_birth', 'วันเกิด'),
                _buildTextFormField('house_number', 'เลขบ้าน'),
                _buildTextFormField('street', 'ถนน'),
                _buildTextFormField('village', 'หมู่บ้าน'),
                _buildTextFormField('subdistrict', 'ตําบล'),
                _buildTextFormField('district', 'อําเภอ'),
                _buildTextFormField('province', 'จังหวัด'),
                _buildTextFormField('weight', 'น้ำหนัก', isNumeric: true),
                _buildTextFormField('height', 'ส่วนสูง', isNumeric: true),
                _buildTextFormField('waist', 'รอบเอว', isNumeric: true),
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

  Widget _buildTextFormField(String key, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: _formData[key]?.toString(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        onSaved: (value) {
          _formData[key] = isNumeric ? double.tryParse(value!) : value;
        },
      ),
    );
  }
}
