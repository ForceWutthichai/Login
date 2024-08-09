import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  EditProfilePage({required this.profileData});

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

  double calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  double calculateWaistToHeightRatio(double waist, double height) {
    return waist / height;
  }

  void _recalculateHealthMetrics() {
    if (_formData['weight'] != null && _formData['height'] != null) {
      _formData['bmi'] = calculateBMI(
        double.parse(_formData['weight']),
        double.parse(_formData['height']),
      ).toStringAsFixed(2);
    }

    if (_formData['waist'] != null && _formData['height'] != null) {
      _formData['waist_to_height_ratio'] = calculateWaistToHeightRatio(
        double.parse(_formData['waist']),
        double.parse(_formData['height']),
      ).toStringAsFixed(2);
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Recalculate BMI and Waist-to-Height Ratio before saving
      _recalculateHealthMetrics();

      try {
        final response = await http.put(
          Uri.parse('http://localhost:3000/profile/${_formData['id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(_formData),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context, true);  // Return true to indicate the profile was updated
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
        initialValue: _formData[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        onChanged: (value) {
          setState(() {
            _formData[key] = value;
            if (key == 'weight' || key == 'height' || key == 'waist') {
              _recalculateHealthMetrics();
            }
          });
        },
        onSaved: (value) {
          _formData[key] = value;
        },
      ),
    );
  }
}
