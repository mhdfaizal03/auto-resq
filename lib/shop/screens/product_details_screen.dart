import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ShopDetailPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const ShopDetailPage(
      {super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final product = products[index];
          return Column(
            children: [
              ShopCards(
                productQuantity: product['quantity'].toString(),
                deliveryDate: product['date'],
                productImage: product['image'],
                productName: product['name'],
                productPrice: product['price'],
                deliveryStatus: product['status'],
                deliveryStatusColor: product['statusColor'],
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
