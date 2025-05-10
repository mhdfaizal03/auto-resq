//Convert image into string

//

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<String> imageToBase64(String imagePath) async {
  final bytes = await File(imagePath).readAsBytes();
  return base64Encode(bytes);
}


// If image is an asset

Future<String> assetImageToBase64(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();
  return base64Encode(bytes);
}

// Convert string into image


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Image base64ToImage(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return Image.memory(bytes);
}

// Apply in ui

String? base64String;


// Convert and display image
Widget build(BuildContext context) {
  if (base64String == null) return CircularProgressIndicator();

  return base64ToImage(base64String!);
}



FULL VERSION

dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.1.2
  firebase_core: ^3.3.0
  cloud_firestore: ^5.2.1

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBase64Screen extends StatefulWidget {
  @override
  _ImageBase64ScreenState createState() => _ImageBase64ScreenState();
}

class _ImageBase64ScreenState extends State<ImageBase64Screen> {
  File? _image;
  String? _base64Image;
  bool _isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _image = File(pickedFile.path);
        _base64Image = base64Encode(imageBytes);
      });
    }
  }

  Future<void> uploadImageAsText() async {
    if (_base64Image == null) return;

    setState(() => _isUploading = true);

    await FirebaseFirestore.instance.collection('base64Images').add({
      'image': _base64Image,
      'createdAt': Timestamp.now(),
    });

    setState(() {
      _isUploading = false;
      _image = null;
      _base64Image = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploaded to Firestore.")));
  }

  Future<List<String>> fetchBase64Images() async {
    final snapshot = await FirebaseFirestore.instance.collection('base64Images').get();
    return snapshot.docs.map((doc) => doc['image'] as String).toList();
  }

  Widget _imageFromBase64(String base64String) {
    final decodedBytes = base64Decode(base64String);
    return Image.memory(decodedBytes, height: 150);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Base64 Image to Firestore')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 150),
            ElevatedButton(onPressed: pickImage, child: Text('Pick Image')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isUploading ? null : uploadImageAsText,
              child: _isUploading ? CircularProgressIndicator() : Text('Upload to Firestore'),
            ),
            SizedBox(height: 20),
            Text('Stored Images:', style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<List<String>>(
              future: fetchBase64Images(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Column(
                  children: snapshot.data!.map((b64) => _imageFromBase64(b64)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


Separating ui and firestore

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  final _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Pick image and return Base64 string
  Future<String?> pickAndConvertToBase64() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }

  // Upload Base64 image to Firestore
  Future<void> uploadBase64Image(String base64Image) async {
    await _firestore.collection('base64Images').add({
      'image': base64Image,
      'createdAt': Timestamp.now(),
    });
  }

  // Fetch all Base64 images
  Future<List<String>> getBase64Images() async {
    final snapshot = await _firestore.collection('base64Images').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => doc['image'] as String).toList();
  }
}



class ImageBase64Screen extends StatefulWidget {
  @override
  _ImageBase64ScreenState createState() => _ImageBase64ScreenState();
}

class _ImageBase64ScreenState extends State<ImageBase64Screen> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  List<String> _base64Images = [];
  bool _loading = false;

  Future<void> _pickAndUploadImage() async {
    setState(() => _loading = true);
    final base64 = await _firebaseServices.pickAndConvertToBase64();
    if (base64 != null) {
      await _firebaseServices.uploadBase64Image(base64);
      await _loadImages();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded')));
    }
    setState(() => _loading = false);
  }

  Future<void> _loadImages() async {
    final images = await _firebaseServices.getBase64Images();
    setState(() => _base64Images = images);
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Base64 Images to Firestore')),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loading ? null : _pickAndUploadImage,
            child: _loading ? CircularProgressIndicator() : Text('Pick & Upload Image'),
          ),
          Expanded(
            child: _base64Images.isEmpty
                ? Center(child: Text('No images found'))
                : ListView.builder(
                    itemCount: _base64Images.length,
                    itemBuilder: (context, index) {
                      final bytes = base64Decode(_base64Images[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(bytes, height: 150),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}