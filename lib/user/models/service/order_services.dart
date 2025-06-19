import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder(Map<String, dynamic> orderData, String shopId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    if (shopId.isEmpty) {
      throw Exception('shopId is required');
    }

    final orderRef = _firestore.collection('ordered_products').doc();

    final newOrder = {
      'orderId': orderRef.id,
      'userId': user.uid,
      'shopId': shopId,
      ...orderData,
    };

    await orderRef.set(newOrder);
  }
}
