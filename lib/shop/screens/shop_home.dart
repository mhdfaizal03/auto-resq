import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';
import 'package:mini_project_1/shop/screens/product_details_screen.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ShopHome extends StatelessWidget {
  final String shopId;
  ShopHome({super.key, required this.shopId});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ordered_products')
                .where('shopId', isEqualTo: shopId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return customLoading();
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong.'));
              }

              final allProducts = snapshot.data?.docs ?? [];

              final total = allProducts.length;
              final packed = allProducts
                  .where(
                      (doc) => (doc['status'] ?? '').toLowerCase() == 'shipped')
                  .length;
              final confirmed = allProducts
                  .where((doc) =>
                      (doc['status'] ?? '').toLowerCase() == 'confirmed')
                  .length;
              final delivered = allProducts
                  .where((doc) =>
                      (doc['status'] ?? '').toLowerCase() == 'delivered')
                  .length;

              final datas = [
                {
                  "number": total,
                  "detailName": "Total Orders",
                  "color": Colors.blue,
                },
                {
                  "number": packed,
                  "detailName": "Packed Products",
                  "color": Colors.red,
                },
                {
                  "number": confirmed,
                  "detailName": "Confirmed Products",
                  "color": Colors.amber,
                },
                {
                  "number": delivered,
                  "detailName": "Delivered Orders",
                  "color": Colors.green,
                }
              ];

              return GridView.builder(
                itemCount: datas.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final item = datas[index];
                  final count = item['number'] as int;
                  final isDisabled = count == 0;

                  return GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShopDetailPage(
                                  title: item['detailName'].toString(),
                                  shopId: shopId,
                                  statusFilter: _getStatusForTitle(
                                      item['detailName'].toString()),
                                ),
                              ),
                            );
                          },
                    child: Opacity(
                      opacity: isDisabled ? 0.5 : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(blurRadius: 1.5, color: Colors.grey),
                          ],
                        ),
                        margin: const EdgeInsets.all(5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 1.5, color: Colors.grey)
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(
                                        color: item['color'] as Color,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['detailName'].toString(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Recent Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ordered_products')
                .where('shopId', isEqualTo: user?.uid)
                // .orderBy('createAt', descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .25,
                  ),
                  child: customLoading(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .25,
                  ),
                  child: const Center(child: Text('No recent orders found.')),
                );
              }

              final recentProducts = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentProducts.length,
                itemBuilder: (context, index) {
                  final product = recentProducts[index];
                  return Column(
                    children: [
                      ShopCards(
                        bottomData: Text(
                          'Delivery in',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        actualPrice: product['price'].toString(),
                        productQuantity: product['quantity'].toString(),
                        deliveryDate: dateFormatter(product['createAt']),
                        productImage: product['image'],
                        productName: product['productName'],
                        productPrice: product['totalPrice'].toString(),
                        deliveryStatus: product['status'],
                        deliveryStatusColor:
                            _getStatusColor(product['status'] ?? ''),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String? _getStatusForTitle(String title) {
    switch (title) {
      case 'Packed Products':
        return 'Shipped';
      case 'Confirmed Products':
        return 'Confirmed';
      case 'Delivered Orders':
        return 'Delivered';
      default:
        return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'packed':
        return Colors.red;
      case 'confirmed':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
