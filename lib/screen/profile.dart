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
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Text(
                '${profileData!['first_name']} ${profileData!['last_name']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                profileData!['title_name'],
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Personal Information',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    _buildProfileCard('ID Card', profileData!['id_card']),
                    _buildProfileCard('Phone', profileData!['phone']),
                    _buildProfileCard('Gender', profileData!['gender']),
                    _buildProfileCard('Date of Birth', profileData!['date_birth']),
                    _buildProfileCard('House Number', profileData!['house_number']),
                    _buildProfileCard('Street', profileData!['street']),
                    _buildProfileCard('Village', profileData!['village']),
                    _buildProfileCard('Subdistrict', profileData!['subdistrict']),
                    _buildProfileCard('District', profileData!['district']),
                    _buildProfileCard('Province', profileData!['province']),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Health Information',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    _buildProfileCard('Weight', profileData!['weight'].toString()),
                    _buildProfileCard('Height', profileData!['height'].toString()),
                    _buildProfileCard('Waist', profileData!['waist'].toString()),
                    _buildProfileCard('BMI', profileData!['bmi'].toString()),
                  ],
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
      color: Colors.teal.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
        ),
      ),
    );
  }
}
