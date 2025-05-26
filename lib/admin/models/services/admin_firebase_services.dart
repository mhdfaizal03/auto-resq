// services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getAdminProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('admins').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
}
