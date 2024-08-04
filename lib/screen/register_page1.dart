import 'dart:convert';
import 'package:final_login/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'register_page2.dart';
import 'constants/color.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Map<String, dynamic> _patientData = {};
  String selectedTitle = 'นาย';
  String selectedGender = 'ชาย';
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String _convertToBuddhistYear(DateTime date) {
    final buddhistCalendarYear = date.year + 543;
    return '${buddhistCalendarYear}-${DateFormat('MM-dd').format(date)}';
  }

  Future<void> _selectDate() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DatePickerWidget(
          initialDate: _selectedDate,
          onDateSelected: (DateTime date) {
            setState(() {
              _selectedDate = date;
            });
          },
        );
      },
    );
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      _patientData.addAll({
        'title_name': selectedTitle,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'id_card': _idCardController.text,
        'phone': _phoneController.text,
        'gender': selectedGender,
        'date_birth': _convertToBuddhistYear(_selectedDate),
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage2(patientData: _patientData),
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
                SizedBox(height: 80),
                Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: textMainColor),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
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
                          });
                        },
                        onSaved: (value) => _patientData['title_name'] = value,
                        decoration: InputDecoration(
                          labelText: 'คำนำหน้า',
                          labelStyle: TextStyle(color: textMainColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'กรุณาเลือกคำนำหน้า' : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อ',
                          labelStyle: TextStyle(color: textMainColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                        ),
                        onSaved: (value) => _patientData['first_name'] = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'นามสกุล',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  onSaved: (value) => _patientData['last_name'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกนามสกุล';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _idCardController,
                  decoration: InputDecoration(
                    labelText: 'เลขบัตรประชาชน',
                    labelStyle: TextStyle(color: textMainColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  onSaved: (value) => _patientData['id_card'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเลขบัตรประชาชน';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทร',
                          labelStyle: TextStyle(color: textMainColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                          ),
                        ),
                        onSaved: (value) => _patientData['phone'] = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกเบอร์โทร';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
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
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'เพศ',
                            labelStyle: TextStyle(color: textMainColor),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1),
                            ),
                          ),
                          onSaved: (value) => _patientData['gender'] = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาเลือกเพศ';
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'วันเกิด: ${_convertToBuddhistYear(_selectedDate)}',
                          style: TextStyle(fontSize: 16, color: textMainColor),
                        ),
                        Icon(Icons.calendar_today, color: textMainColor),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
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

class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  DatePickerWidget({required this.initialDate, required this.onDateSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year + 543;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'เลือกวันที่',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: _selectedYear,
                  items: List.generate(100, (index) {
                    final year = DateTime.now().year + 543 - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  value: _selectedMonth,
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text('${month.toString().padLeft(2, '0')}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  value: _selectedDay,
                  items: List.generate(31, (index) {
                    final day = index + 1;
                    return DropdownMenuItem(
                      value: day,
                      child: Text('${day.toString().padLeft(2, '0')}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final selectedDate = _convertToGregorian(
                _selectedYear,
                _selectedMonth,
                _selectedDay,
              );
              widget.onDateSelected(selectedDate);
              Navigator.pop(context);
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  DateTime _convertToGregorian(int buddhistYear, int month, int day) {
    return DateTime(buddhistYear - 543, month, day);
  }
}
