import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      _nameController.text = doc['username'] ?? '';
      currentImageUrl = doc['profileImageUrl'] ?? '';
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied to access gallery")),
      );
    }
  }

  Future<String?> _uploadImage(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${user.uid}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    String? imageUrl = currentImageUrl;

    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': _nameController.text.trim(),
      'profileImageUrl': imageUrl ?? '',
    });

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _imageFile != null
                                ? FileImage(_imageFile!)
                                : (currentImageUrl.isNotEmpty
                                    ? NetworkImage(currentImageUrl)
                                    : AssetImage('assets/user.jpg')
                                        as ImageProvider),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
    );
  }
}
