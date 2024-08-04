import 'package:flutter/material.dart';

class MockData extends ChangeNotifier {
  List<Map<String, String?>> users = [];
  Map<String, String?>? logInUser;

  bool login(String phone, String password) {
    for (var user in users) {
      if (user['phone'] == phone && user['password'] == password) {
        logInUser = user;
        notifyListeners();
        return true;
      }
    }
    return false;
  }
  //notifyListeners();อัปเดตโดยอัตโนมัติหลังจากเข้าสู่ระบบสำเร็จ

  void registerUser(
    String title,
    String firstName,
    String lastName,
    String password,
    String houseNumber,
    String subDistrict,
    String district,
    String province,
    String phoneNumber,
    String gender,
    String idCard,
    String dateOfBirth,
    String? weight,
    String? height,
  ) {
    users.add({
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'houseNumber': houseNumber,
      'subDistrict': subDistrict,
      'district': district,
      'province': province,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'idCard': idCard,
      'dateOfBirth': dateOfBirth,
      'weight': weight,
      'height': height,
    });
    notifyListeners();
  }

  String calculateBMI(String? weight, String? height) {
    if (weight != null && height != null) {
      final w = double.parse(weight);
      final h = double.parse(height) / 100;
      final bmi = w / (h * h);
      return bmi.toStringAsFixed(2);
    }
    return 'ยังไม่ได้กรอกข้อมูล';
  }
}
