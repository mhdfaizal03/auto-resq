import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mini_project_1/all_auth_services/model/user_register_auth_model.dart';

class StringImages {
  Widget base64ToImage(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }

  Future<String> assetImageToBase64(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    return base64Encode(bytes);
  }

  Future<String> fileBytesToBase64(Uint8List fileBytes) async {
    return base64Encode(fileBytes);
  }
}

class FirebaseImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfileWithImage({
    required UserRegisterAuthModel userModel,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap());
    } catch (e) {
      throw Exception("Failed to save user profile: $e");
    }
  }

  Future<UserRegisterAuthModel?> getUserById(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (doc.exists) {
      return UserRegisterAuthModel.fromMap(doc.data()!);
    }
    return null;
  }
}
