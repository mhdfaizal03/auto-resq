import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/all_auth_services/model/user_create_request_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required String location,
    required String role,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      Map<String, dynamic> commonData = {
        'uid': uid,
        'name': name,
        'email': email,
        'mobile': mobile,
        'location': location,
        'role': role,
        'profileUrl': '',
        'createdAt': Timestamp.now(),
      };

      if (role == 'User') {
        await _firestore.collection('users').doc(uid).set(commonData);
      } else if (role == 'Mechanic') {
        await _firestore.collection('mechanics').doc(uid).set({
          ...commonData,
          'professionalDataCompleted': false,
        });
      } else if (role == 'Shop') {
        await _firestore.collection('shops').doc(uid).set(commonData);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) return 'User';

      final mechDoc = await _firestore.collection('mechanics').doc(uid).get();
      if (mechDoc.exists) return 'Mechanic';

      final shopDoc = await _firestore.collection('shops').doc(uid).get();
      if (shopDoc.exists) return 'Shop';

      return null;
    } catch (e) {
      return null;
    }
  }

  void logoutUser() {
    _auth.signOut();
  }
}

class FirebaseFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitMechanicRequest(UserCreateRequestModel request) async {
    try {
      await _firestore.collection('mechanic_requests').add({
        ...request.toMap(),
        'status': 'Requested',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit request: $e');
    }
  }

  Future<void> updateMechanicDetails({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String profileUrl,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'mobile': phone,
      'location': location,
      'profileUrl': profileUrl,
    });
  }
}
