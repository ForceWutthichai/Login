import 'package:final_login/constants/color.dart';
import 'package:flutter/material.dart';
import 'register_page3.dart';
import 'constants/color.dart';

class RegisterPage2 extends StatefulWidget {
  final Map<String, dynamic> patientData;

  RegisterPage2({required this.patientData});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (_formKey.currentState!.validate()) {
      widget.patientData.addAll({
        'house_number': _houseNumberController.text,
        'street': _streetController.text,
        'village': _villageController.text,
        'subdistrict': _subDistrictController.text,
        'district': _districtController.text,
        'province': _provinceController.text,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage3(patientData: widget.patientData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'ที่อยู่',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: textMainColor,
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _houseNumberController,
                  decoration: InputDecoration(
                    labelText: 'บ้านเลขที่',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'กรุณากรอกบ้านเลขที่'
                      : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    labelText: 'ถนน',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกถนน' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _villageController,
                  decoration: InputDecoration(
                    labelText: 'หมู่',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกหมู่' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _subDistrictController,
                  decoration: InputDecoration(
                    labelText: 'ตำบล',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกตำบล' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: 'อำเภอ',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกอำเภอ' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _provinceController,
                  decoration: InputDecoration(
                    labelText: 'จังหวัด',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'กรุณากรอกจังหวัด'
                      : null,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'กลับหน้าก่อนหน้า',
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
                    backgroundColor: borderColor2,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    'ถัดไป',
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
                    backgroundColor: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
