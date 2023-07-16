import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController whatsappNumberController =TextEditingController();
  File? _imageFile;
  String imagePath = '';
  final ImagePicker _imagePicker = ImagePicker();

  void _updateProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String name = nameController.text;
      String address = addressController.text;
      String whatsappNumber = whatsappNumberController.text;

      // Update the profile data in Firestore
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': name,
          'address': address,
          'image': imagePath,
          'whatsappNumber': whatsappNumber,
        });

        // Show a success message or perform any other actions

        // Navigate back to the profile page
        Navigator.pop(context);
      } catch (e) {
        // Handle any errors that occurred during the update process
        print('Error updating profile data: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    whatsappNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Personal Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: whatsappNumberController,
              decoration: InputDecoration(
                labelText: 'WhatsApp Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProfileData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}