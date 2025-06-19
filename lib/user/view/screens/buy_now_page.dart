import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/user/models/service/order_services.dart';
import 'package:mini_project_1/user/view/screens/my_orders_page.dart';
import 'package:mini_project_1/user/view/screens/user_navbar_page.dart';
import 'package:mini_project_1/user/view/screens/user_shop.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String shopId;
  const BuyNowPage({super.key, required this.product, required this.shopId});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  bool isLoading = false;
  int counter = 1;
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _confirmOrder() async {
    if (locationController.text.trim().isEmpty) {
      CustomSnackBar.show(
          context: context,
          message: "Please enter your location.",
          color: Colors.red);
      return;
    }

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    final ordererName = userData['name'];

    setState(() {
      isLoading = true;
    });

    try {
      final orderData = {
        'orderer_name': ordererName,
        'shopId': widget.shopId,
        'productId': widget.product['productId'],
        'productName': widget.product['productName'],
        'brandName': widget.product['brandName'],
        'price': widget.product['price'],
        'discountPrice': widget.product['discountPrice'],
        'image': widget.product['image'],
        'quantity': counter,
        'totalPrice': widget.product['discountPrice'] * counter,
        'location': locationController.text.trim(),
        'createAt': FieldValue.serverTimestamp(),
        'order_placed_date': null,
        'order_confirmed_date': null,
        'order_shipped_date': null,
        'out_of_delivery_date': null,
        'delivered_date': null,
        'status': 'Pending'
      };

      await OrderService().placeOrder(orderData, widget.shopId);

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserNavPage()));
      CustomSnackBar.show(
          context: context,
          message: "Order placed successfully!",
          color: Colors.green);

      customAlertWidget(
          content: Text(
            'Ordered Successfully',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          context: context,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrdersPage(),
                    ));
              },
              child: Text('Go to Orders'),
            ),
          ]);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomSnackBar.show(
          context: context,
          message: "Order failed: ${e.toString()}",
          color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                const SizedBox(height: 10),
                buildLabel('Location'),
                const SizedBox(height: 10),
                CustomTextField(
                  text: 'Enter your location',
                  controller: locationController,
                  minLines: 2,
                  maxLines: 2,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildLabel('Product Details'),
                const SizedBox(height: 10),
                buildProductCard(),
                const SizedBox(height: 25),
                infoBox(),
                const SizedBox(height: 30),
                buildLabel('Payment Details'),
                const SizedBox(height: 20),
                buildPaymentDetails(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: CustomMaterialButtom(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              customAlertWidget(
                context: context,
                content: Text(
                  'Are you sure want to confirm this Order?',
                  style: TextStyle(
                    fontSize: mq.width * 0.050,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text('Cancel', style: TextStyle(color: primaryColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmOrder();
                    },
                    child: Text('Order Now',
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              );
            }
          },
          buttonText: 'Buy Now',
        ),
      ),
    );
  }

  Widget buildProductCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration(),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(15),
              decoration: boxDecoration(),
              child: CachedNetworkImage(
                imageUrl: widget.product['image'] ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel(widget.product['productName'] ?? 'N/A'),
                Text(widget.product['brandName'] ?? 'N/A'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    buildLabel('₹${widget.product['discountPrice'] ?? 'N/A'}'),
                    const SizedBox(width: 10),
                    Text(
                      '₹${widget.product['price'] ?? 'N/A'}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    quantityButton(Icons.remove, () {
                      setState(() {
                        if (counter > 1) counter--;
                      });
                    }),
                    const SizedBox(width: 10),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Center(child: buildLabel('$counter')),
                    ),
                    const SizedBox(width: 10),
                    quantityButton(Icons.add, () {
                      setState(() {
                        counter++;
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 30,
          width: 30,
          color: Colors.grey,
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
    );
  }

  Widget infoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: boxDecoration(),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.red),
          SizedBox(width: 10),
          Text('Order Cancellation not Available',
              style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget buildPaymentDetails() {
    final discountPrice = widget.product['discountPrice'] ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: boxDecoration(),
      child: Column(
        children: [
          buildPriceRow('Price (Per item)', '₹$discountPrice'),
          const SizedBox(height: 15),
          buildPriceRow('Delivery charge', '₹0', color: Colors.green),
          const SizedBox(height: 15),
          const Divider(thickness: 1.5, color: Colors.black),
          const SizedBox(height: 15),
          buildPriceRow('Total Amount', '₹${discountPrice * counter}',
              isBold: true),
        ],
      ),
    );
  }

  Widget buildPriceRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLabel(label),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: mq.width * 0.045,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 2.5)],
    );
  }
}
