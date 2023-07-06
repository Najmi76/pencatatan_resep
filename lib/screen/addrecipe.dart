import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resep/models/class.dart';

class ResepInputPage extends StatefulWidget {
  @override
  _ResepInputPageState createState() => _ResepInputPageState();
}

class _ResepInputPageState extends State<ResepInputPage> {
  final TextEditingController resepNameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController cookingStepsController = TextEditingController();

  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  String imagePath = '';

  @override
  void dispose() {
    resepNameController.dispose();
    ingredientsController.dispose();
    cookingStepsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        imagePath = pickedFile.path;

        print("image $_imageFile");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Input Resep'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: resepNameController,
              decoration: InputDecoration(
                labelText: 'Resep Name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
              },
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16.0),
            if (_imageFile != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Image:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Image.file(
                    File(_imageFile!.path),
                    height: 200.0,
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(
                labelText: 'Ingredients',
              ),
              onChanged: (value) {
                // Split the text by line breaks and join with semicolons
                String formattedText = value.split('\n').join(';');
                ingredientsController.value =
                    ingredientsController.value.copyWith(
                  text: formattedText,
                  selection:
                      TextSelection.collapsed(offset: formattedText.length),
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: cookingStepsController,
              decoration: InputDecoration(
                labelText: 'Cooking Steps',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String resepName = resepNameController.text;
                String ingredients = ingredientsController.text;
                String cookingSteps = cookingStepsController.text;

                // Generate unique ID for the resep
                String idResep =
                    FirebaseFirestore.instance.collection('Resep').doc().id;

                Resep resep = Resep(
                  id_resep: idResep,
                  username: email,
                  bahan: ingredients,
                  deskripsi: cookingSteps,
                  id_menu: '',
                  id_kategori: '',
                  image: imagePath,
                );

                FirebaseFirestore.instance
                    .collection('Resep')
                    .doc(idResep)
                    .set(resep.toMap())
                    .then((_) {
                  // Data resep berhasil ditambahkan
                  // Tambahkan logika atau navigasi ke halaman lain di sini
                }).catchError((error) {
                  // Terjadi kesalahan saat menambahkan data resep
                  print('Error adding resep: $error');
                });
              },
              child: Text('Save Resep'),
            ),
          ],
        ),
      ),
    );
  }
}