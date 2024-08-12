import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _phone = '';
  String _vehicleType = '';
  int _totalDeliveries = 0;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // In a real app, you'd fetch this data from an API or local database
    setState(() {
      _name = 'fadi saidi';
      _email = 'fadi@gmail.com';
      _phone = '+1 234 567 8900';
      _vehicleType = 'Car';
      _totalDeliveries = 150;
      _rating = 4.8;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: getImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value!,
                    validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (value) => _email = value!,
                    validator: (value) => !value!.contains('@') ? 'Please enter a valid email' : null,
                  ),
                  TextFormField(
                    initialValue: _phone,
                    decoration: InputDecoration(labelText: 'Phone'),
                    onSaved: (value) => _phone = value!,
                    validator: (value) => value!.length < 10 ? 'Please enter a valid phone number' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _vehicleType,
                    decoration: InputDecoration(labelText: 'Vehicle Type'),
                    items: ['Car', 'Motorcycle', 'Bicycle', 'Van']
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _vehicleType = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Performance',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListTile(
              title: Text('Total Deliveries'),
              trailing: Text('$_totalDeliveries'),
            ),
            ListTile(
              title: Text('Rating'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$_rating'),
                  Icon(Icons.star, color: Colors.amber),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update Profile'),
              onPressed: _updateProfile,
            ),
            SizedBox(height: 20),
            OutlinedButton(
              child: Text('Change Password'),
              onPressed: () => _showChangePasswordDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String oldPassword = '';
        String newPassword = '';
        String confirmPassword = '';

        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
                onChanged: (value) => oldPassword = value,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                onChanged: (value) => newPassword = value,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                onChanged: (value) => confirmPassword = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Change Password'),
              onPressed: () {
                if (newPassword == confirmPassword) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password changed successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}