import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ShopDetailPage extends StatelessWidget {
  final String title;
  final String shopId;
  final String? statusFilter;

  const ShopDetailPage({
    super.key,
    required this.title,
    required this.shopId,
    this.statusFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getProductStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return customLoading();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No recent products found.'));
          }

          final recentProducts = snapshot.data!.docs.map((doc) {
            return ProductModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: recentProducts.length,
              itemBuilder: (context, index) {
                final product = recentProducts[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: AlertDialog(
                                insetPadding: EdgeInsets.all(10),
                                contentPadding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.white,
                                content: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 1.5,
                                                      color: Colors.grey)
                                                ]),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                'https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
                                                        children: [
                                                      TextSpan(
                                                          text: 'Status | ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      TextSpan(
                                                          text: product
                                                              .productName
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: _getStatusColor(
                                                                  product
                                                                      .productStatus!))),
                                                    ])),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${product.productName.toString()} (${product.stocksLeft.toString()})',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      product.productName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '₹${product.discountPrice.toString()}',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '₹${product.price.toString()}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ]),
                                      Text('User Name'),
                                      buildLabel("Johns"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Location'),
                                      buildLabel(
                                          "4517 Washington Ave. Manchester, Kentucky 39495"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Quantity'),
                                      buildLabel("2"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Delivery'),
                                      buildLabel("22/03/25"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ShopCards(
                        bottomData: Text(
                          'Delivery in ${formatDate(product.createdAt!)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        actualPrice: product.price.toString(),
                        productQuantity: product.stocksLeft.toString(),
                        deliveryDate: product.createdAt!
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        productImage: product.productImage,
                        productName: product.productName,
                        productPrice: product.discountPrice.toString(),
                        deliveryStatus: product.productStatus,
                        deliveryStatusColor:
                            _getStatusColor(product.productStatus ?? ''),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Firestore stream with optional status filter
  Stream<QuerySnapshot> _getProductStream() {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('shopId', isEqualTo: shopId)
        .limit(5);

    if (statusFilter != null && statusFilter!.isNotEmpty) {
      query = query.where('productStatus', isEqualTo: statusFilter);
    }

    return query.snapshots();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Available':
        return primaryColor;
      case 'Packed':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
