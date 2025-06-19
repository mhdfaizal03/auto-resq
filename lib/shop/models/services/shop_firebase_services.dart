// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mini_project_1/shop/models/model/product_model.dart';

// class FirebaseProductService {
//   final CollectionReference _productRef =
//       FirebaseFirestore.instance.collection('products');

//   String? get _userId => FirebaseAuth.instance.currentUser?.uid;

//   /// Add a new product
//   Future<void> addProduct(ProductModel product) async {
//     var productId =
//         await FirebaseFirestore.instance.collection("products").doc().id;

//     try {
//       await _productRef.doc(productId).set(product.toMap(productId));
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// Stream all products for the current shop
//   Stream<List<ProductModel>> streamAllProducts() {
//     final shopId = _userId;
//     if (shopId == null) {
//       return const Stream.empty();
//     }

//     return _productRef.where('shopId', isEqualTo: shopId).snapshots().map(
//         (snapshot) => snapshot.docs
//             .map((doc) =>
//                 ProductModel.fromMap(doc.data() as Map<String, dynamic>))
//             .toList());
//   }

//   /// Update an existing product
//   Future<void> updateProduct(String productId, ProductModel product) async {
//     var productId =
//         await FirebaseFirestore.instance.collection("products").doc().id;
//     try {
//       await _productRef.doc(productId).update(product.toMap(productId));
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// Delete a product by productId
//   Future<void> deleteProduct(String productId) async {
//     try {
//       await _productRef.doc(productId).delete();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/product_model.dart';

class FirebaseProductService {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('products');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Stream<List<ProductModel>> streamAllProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Add a new product
  Future<void> addProduct(ProductModel product) async {
    final docRef = _productRef.doc(); // Generate a new document ID
    final productData = product.toMap(docRef.id);
    productData['shopId'] = _userId;
    productData['createdAt'] = FieldValue.serverTimestamp();

    await docRef.set(productData);
  }

  /// Update an existing product
  Future<void> updateProduct(String productId, ProductModel product) async {
    final docRef = _productRef.doc(productId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      throw Exception("Product not found");
    }

    await docRef.update(product.toMap(productId));
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    await _productRef.doc(productId).delete();
    await _firestore.collection('ordered_products').doc(productId).delete();
  }

  Future<List<ProductModel>> getProductsByShop(String shopId) async {
    final querySnapshot =
        await _productRef.where('shopId', isEqualTo: shopId).get();

    return querySnapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _productRef.doc(productId).get();
    if (doc.exists) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
