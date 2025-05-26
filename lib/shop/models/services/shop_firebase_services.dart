import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';

class FirebaseProductService {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('products');

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Add a new product
  Future<void> addProduct(ProductModel product) async {
    try {
      await _productRef.add(product.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Stream all products for the current shop
  Stream<List<ProductModel>> streamAllProducts() {
    final shopId = _userId;
    if (shopId == null) {
      return const Stream.empty();
    }

    return _productRef
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return ProductModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList());
  }

  /// Fetch all products (one-time fetch)
  Future<List<ProductModel>> fetchAllProducts() async {
    final shopId = _userId;
    if (shopId == null) return [];

    try {
      QuerySnapshot snapshot =
          await _productRef.where('shopId', isEqualTo: shopId).get();

      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Update a product by document ID
  Future<void> updateProduct(String shopId, ProductModel product) async {
    final docRef = FirebaseFirestore.instance
        .collection('products')
        .doc(product.productId); // Use the correct productId

    final data = product.toMap(); // Convert product to Map
    await docRef.update(data);
  }

  /// Delete a product by document ID
  Future<void> deleteProduct(String docId) async {
    try {
      await _productRef.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
