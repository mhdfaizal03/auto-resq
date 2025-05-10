import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/all_auth_services/model/user_create_request_model.dart';
import 'package:mini_project_1/all_auth_services/model/user_register_auth_model.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String> uploadImageToStorage({
  //   required Uint8List imageBytes,
  //   required String fileName,
  //   required String folder,
  // }) async {
  //   Reference ref = _storage.ref().child(folder).child(fileName);
  //   UploadTask uploadTask = ref.putData(imageBytes);
  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  /// Saves professional details to Firestore under 'mechanics' collection
  Future<void> saveProfessionalDetails({
    required String workshopName,
    required String workshopAddress,
    required String experience,
    required List<String> specializations,
    required String idProofName,
    required String profileImageUrl,
  }) async {
    String uid = _auth.currentUser!.uid;

    await _firestore.collection('mechanics').doc(uid).update({
      'workshopName': workshopName,
      'workshopAddress': workshopAddress,
      'experience': experience,
      'specializations': specializations,
      'idProofName': idProofName,
      'profileImageUrl': profileImageUrl,
      'professionalDataCompleted': true,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class FirebaseMechanicService {
  final _db = FirebaseFirestore.instance;

//   Future<List<UserCreateRequestModel>> fetchAllRequests() async {
//   final currentUid = FirebaseAuth.instance.currentUser!.uid;

//   final snapshot = await _db
//       .collection('mechanic_requests')
//       .where(Filter.or(
//         Filter('status', isEqualTo: 'Requested'),
//         Filter('assignedMechanicId', isEqualTo: currentUid),
//       ))
//       .orderBy('createdAt', descending: true)
//       .get();

//   return snapshot.docs.map((doc) {
//     final data = doc.data();
//     return UserCreateRequestModel.fromMap({
//       ...data,
//       'id': doc.id,
//     });
//   }).toList();
// }

  Future<List<UserCreateRequestModel>> fetchAllRequests() async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await _db
        .collection('mechanic_requests')
        .where(Filter.or(
          Filter('status', isEqualTo: 'Requested'),
          Filter('assignedMechanicId', isEqualTo: currentUid),
        ))
        .where('status', isNotEqualTo: 'Work Completed') // 👈 add this here
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UserCreateRequestModel.fromMap({
        ...data,
        'id': doc.id,
      });
    }).toList();
  }

  Future<void> updateStatusAndAmount({
    required String id,
    required String status,
    required bool isPaid,
    double? amount,
  }) async {
    final updateData = {
      'status': status,
      'isPaid': isPaid,
    };

    if (status == 'Work Completed' && amount != null) {
      updateData['amount'] = amount.toString();
    }

    await _db.collection('mechanic_requests').doc(id).update(updateData);
  }

  Future<void> acceptRequest({
    required String requestId,
    required String workShopName,
    required String mechanicName,
  }) async {
    final mechanicUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('mechanic_requests')
        .doc(requestId)
        .update({
      'status': 'Mechanic Picked',
      'workShopName': workShopName,
      'assignedMechanicName': mechanicName,
      'assignedMechanicId': mechanicUid,
      'acceptedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfessionalDetails({
    required String workshopName,
    required String workshopAddress,
    required String experience,
    required List<String> specializations,
    required String idProofName,
    Uint8List? profileImageBytes,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? profileImageUrl;

    // if (profileImageBytes != null) {
    //   profileImageUrl = await uploadImageToStorage(
    //     imageBytes: profileImageBytes,
    //     fileName: '${DateTime.now().millisecondsSinceEpoch}_profile.jpg',
    //     folder: 'profile_images',
    //   );
    // }

    await FirebaseFirestore.instance.collection('mechanics').doc(uid).update({
      'workshopName': workshopName,
      'workshopAddress': workshopAddress,
      'experience': experience,
      'specializations': specializations,
      'idProofName': idProofName,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    });
  }
}
