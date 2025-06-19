import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? productId;
  final String? productName;
  final String? productDescription;
  final String? productCategory;
  final String? productSpecification;
  final String? productStatus;
  final String? productImage;
  final double? price;
  final double? discountPrice;
  final int? stocksLeft;
  final DateTime? createdAt;
  final String? shopId;
  final String? orderBy;
  final String? ordertoLocation;
  final int? quantity;
  final String? deliveryDate;
  final String? brandName;

  ProductModel({
    this.productId,
    this.productName,
    this.productDescription,
    this.productCategory,
    this.productSpecification,
    this.productStatus,
    this.productImage,
    this.price,
    this.discountPrice,
    this.stocksLeft,
    this.createdAt,
    this.shopId,
    this.orderBy,
    this.ordertoLocation,
    this.deliveryDate,
    this.quantity,
    this.brandName,
  });

  Map<String, dynamic> toMap(String? productIds) {
    return {
      'productId': productIds,
      'productName': productName,
      'productDescription': productDescription,
      'productCategory': productCategory,
      'productSpecification': productSpecification,
      'status': productStatus,
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'stocksLeft': stocksLeft,
      'createdAt': createdAt,
      'shopId': shopId,
      'orderBy': orderBy,
      'ordertoLocation': ordertoLocation,
      'quantity': quantity,
      'deliveryDate': deliveryDate,
      'brandName': brandName,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return ProductModel(
      productId: id,
      productName: map['productName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productCategory: map['productCategory'] ?? '',
      productSpecification: map['productSpecification'] ?? '',
      productStatus: map['status'] ?? 'Pending',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: (map['discountPrice'] ?? 0).toDouble(),
      stocksLeft: (map['stocksLeft'] ?? 0).toInt(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      shopId: map['shopId'] ?? '',
      orderBy: map['orderBy'] ?? '',
      ordertoLocation: map['ordertoLocation'] ?? '',
      quantity: (map['quantity'] ?? 0).toInt(),
      deliveryDate: map['deliveryDate'] ?? '',
      brandName: map['brandName'] ?? '',
    );
  }
}
