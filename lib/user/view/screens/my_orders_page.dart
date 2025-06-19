import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/user/models/service/order_services.dart';
import 'package:mini_project_1/user/view/screens/buy_now_page.dart';
import 'package:mini_project_1/user/view/screens/inner_categories_page.dart';
import 'package:mini_project_1/user/view/screens/track_orders.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ordered_products')
                      .where('userId', isEqualTo: uid)
                      .where('status', isNotEqualTo: 'Delivered')
                      // .orderBy('orderDate', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return customLoading();

                    final orders = snapshot.data!.docs;

                    if (orders.isEmpty) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: mq.height * 0.7,
                          ),
                          child: Center(child: Text('No orders found.')));
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order =
                            orders[index].data() as Map<String, dynamic>;

                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 1.5)
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                blurRadius: 1.5)
                                          ]),
                                      child: Center(
                                        child: Image.network(
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          },
                                          order['image'] ?? '',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('status'),
                                            Text(' | '),
                                            Text('${order['status']}'),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        buildLabel('${order['productName']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('${order['brandName']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('Quantity: ${order['quantity']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('Price: ${order['totalPrice']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'Order Date: ${dateFormatter(order['orderedAt'])}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomMaterialButtom(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BuyNowPage(
                                                    product: order,
                                                    shopId: order['shopId'],
                                                  )));
                                    },
                                    buttonText: 'Order Again',
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  CustomMaterialButtom(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TrackOrderPage(order: order),
                                        ),
                                      );
                                    },
                                    buttonText: 'Track Order',
                                    color: primaryColor,
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
