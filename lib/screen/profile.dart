import 'package:final_login/screen/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final int? userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _fetchProfileData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid user ID')),
      );
    }
  }

  Future<void> _fetchProfileData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/profile/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data')),
      );
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(profileData: profileData!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF2A6F97),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                '${profileData!['title_name']} ${profileData!['first_name']} ${profileData!['last_name']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003566),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                color: Color(0xFFD9D9D9),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003566),
                        ),
                      ),
                    ),
                    Divider(),
                    _buildProfileCard('เลขบัตรประชาชน', profileData!['id_card']),
                    _buildProfileCard('เบอร์โทร', profileData!['phone']),
                    _buildProfileCard('เพศ', profileData!['gender']),
                    _buildProfileCard('ปีเกิด', profileData!['date_birth']),
                    _buildProfileCard('เลขบ้าน', profileData!['house_number']),
                    _buildProfileCard('ถนน', profileData!['street']),
                    _buildProfileCard('หมู่บ้าน', profileData!['village']),
                    _buildProfileCard('ตําบล', profileData!['subdistrict']),
                    _buildProfileCard('อําเภอ', profileData!['district']),
                    _buildProfileCard('จังหวัด', profileData!['province']),
                  ],
                ),
              ),
              Card(
                color: Color(0xFFD9D9D9),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Health Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003566),
                        ),
                      ),
                    ),
                    Divider(),
                    _buildProfileCard('น้ำหนัก', profileData!['weight'].toString()),
                    _buildProfileCard('ส่วนสูง', profileData!['height'].toString()),
                    _buildProfileCard('รอบเอว', profileData!['waist'].toString()),
                    _buildProfileCard('ค่า BMI', profileData!['bmi'].toString()),
                    _buildProfileCard('ค่า รอบเอวต่อส่วนสูง', profileData!['waist_to_height_ratio'].toString()),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'กลับสู่หน้าล็อกอิน',
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
    );
  }

  Widget _buildProfileCard(String title, String value) {
    return Card(
      color: Color(0xFFEDF2F4),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF003566),
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF003566),
          ),
        ),
      ),
    );
  }
}
