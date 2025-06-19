// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mini_project_1/shop/models/model/product_model.dart';
// import 'package:mini_project_1/utils/colors.dart';
// import 'package:mini_project_1/utils/time_and_date_formats.dart';
// import 'package:mini_project_1/utils/widgets.dart';

// class ShopDetailPage extends StatelessWidget {
//   final String title;
//   final String shopId;
//   final String? statusFilter;

//   ShopDetailPage({
//     super.key,
//     required this.title,
//     required this.shopId,
//     this.statusFilter,
//   });

//   String selectedCategory = "";

//   final List<Map<String, dynamic>> steps = [
//     {
//       'status': 'Confirmed',
//       'date': 'order_confirmed_date',
//     },
//     {
//       'status': 'Shipped',
//       'date': 'order_shipped_date',
//     },
//     {
//       'status': 'Out of Delivery',
//       'date': 'out_of_delivery_date',
//     },
//     {
//       'status': 'Delivered',
//       'date': 'delivered_date',
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _getProductStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return customLoading();
//           }

//           // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           //   return const Center(child: Text('No recent products found.'));
//           // }

//           final orderData = snapshot.data?.docs;

//           if (orderData == null ||
//               !snapshot.hasData ||
//               snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No recent products found.'));
//           }

//           final recentProducts = snapshot.data!.docs.map((doc) {
//             return ProductModel.fromMap(
//               doc.data() as Map<String, dynamic>,
//               doc.id,
//             );
//           }).toList();

//           return Padding(
//             padding: const EdgeInsets.all(10),
//             child: ListView.builder(
//               itemCount: recentProducts.length,
//               itemBuilder: (context, index) {
//                 final product = recentProducts[index];
//                 return Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                               child: AlertDialog(
//                                 insetPadding: EdgeInsets.all(10),
//                                 contentPadding: EdgeInsets.all(10),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 backgroundColor: Colors.white,
//                                 content: Container(
//                                   decoration:
//                                       BoxDecoration(color: Colors.white),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Row(children: [
//                                         Expanded(
//                                           flex: 3,
//                                           child: Container(
//                                             padding: EdgeInsets.all(10),
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 color: Colors.white,
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                       blurRadius: 1.5,
//                                                       color: Colors.grey)
//                                                 ]),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: Image.network(
//                                                 'https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg',
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Expanded(
//                                             flex: 5,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 RichText(
//                                                     text: TextSpan(
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins'),
//                                                         children: [
//                                                       TextSpan(
//                                                           text: 'Status | ',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.grey)),
//                                                       TextSpan(
//                                                           text:
//                                                               '${orderData[index]['productName']}',
//                                                           style: TextStyle(
//                                                               color: _getStatusColor(
//                                                                   product
//                                                                       .productStatus!))),
//                                                     ])),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '${orderData[index]['productName']} (${orderData[index]['quantity']})',
//                                                       style: TextStyle(
//                                                           fontSize: 20,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       '${orderData[index]['productName']}',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           '₹${orderData[index]['totalPrice']}',
//                                                           style: TextStyle(
//                                                               fontSize: 20,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Text(
//                                                           '₹${orderData[index]['price']}',
//                                                           style: TextStyle(
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: Colors.red,
//                                                               decoration:
//                                                                   TextDecoration
//                                                                       .lineThrough,
//                                                               decorationColor:
//                                                                   Colors.red),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ))
//                                       ]),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text('User Name'),
//                                       buildLabel(
//                                         '${orderData[index]['orderer_name']}',
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       Text('Location'),
//                                       buildLabel(orderData[index]['location']),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       Text('Quantity'),
//                                       buildLabel(
//                                           '${orderData[index]['quantity']}'),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       Text('Delivery'),
//                                       buildLabel("22/03/25"),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       Text('Status'),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Container(
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               color: Colors.white,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                     blurRadius: 1.5,
//                                                     color: Colors.grey)
//                                               ]),
//                                           child: ListTile(
//                                               onTap: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) {
//                                                     return StatefulBuilder(
//                                                       builder: (context,
//                                                           setStateDialog) {
//                                                         return CustomSpecificationsDialog(
//                                                           headerItems:
//                                                               const Padding(
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                     horizontal:
//                                                                         20,
//                                                                     vertical:
//                                                                         18),
//                                                             child: Text(
//                                                               'Select Category',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                           ),
//                                                           context: context,
//                                                           children:
//                                                               List.generate(
//                                                                   steps.length,
//                                                                   (index) {
//                                                             String item =
//                                                                 steps[index]
//                                                                     ['status'];
//                                                             bool isSelected =
//                                                                 selectedCategory ==
//                                                                     item;
//                                                             return Column(
//                                                               children: [
//                                                                 const Divider(),
//                                                                 ListTile(
//                                                                   title: Text(
//                                                                     item,
//                                                                     style: TextStyle(
//                                                                         color: _getStatusColor(
//                                                                             item)),
//                                                                   ),
//                                                                   trailing:
//                                                                       Icon(
//                                                                     isSelected
//                                                                         ? Icons
//                                                                             .radio_button_on
//                                                                         : Icons
//                                                                             .radio_button_off,
//                                                                   ),
//                                                                   onTap: () {
//                                                                     setStateDialog(
//                                                                         () {
//                                                                       selectedCategory =
//                                                                           item;
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ],
//                                                             );
//                                                           }),
//                                                           actionButton:
//                                                               MaterialButton(
//                                                             height: 60,
//                                                             shape:
//                                                                 const RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .only(
//                                                                 bottomLeft: Radius
//                                                                     .circular(
//                                                                         10),
//                                                                 bottomRight:
//                                                                     Radius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             minWidth:
//                                                                 double.infinity,
//                                                             color: Colors
//                                                                 .blue[500],
//                                                             onPressed:
//                                                                 () async {
//                                                               await updateOrderStatusAndDate(
//                                                                 documentId:
//                                                                     orderData[
//                                                                             index]
//                                                                         .id,
//                                                                 newStatus:
//                                                                     selectedCategory,
//                                                               );
//                                                               Navigator.pop(
//                                                                   context);
//                                                             },
//                                                             child: const Text(
//                                                               'Save',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                               title: Text(
//                                                   '${orderData[index]['status']}'),
//                                               trailing: Icon(Icons
//                                                   .keyboard_arrow_down_rounded)))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       child: ShopCards(
//                         bottomData: Text(
//                           '',
//                           // 'Delivery in ${formatDate(product.createdAt!)}',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         actualPrice: product.price.toString(),
//                         productQuantity: product.stocksLeft.toString(),
//                         deliveryDate: dateFormatter(product.createdAt),
//                         productImage: product.productImage,
//                         productName: product.productName,
//                         productPrice: product.discountPrice.toString(),
//                         deliveryStatus: product.productStatus,
//                         deliveryStatusColor:
//                             _getStatusColor(product.productStatus ?? ''),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> updateOrderStatusAndDate({
//     required String documentId,
//     required String newStatus,
//   }) async {
//     final statusDateFields = {
//       'Confirmed': 'order_confirmed_date',
//       'Shipped': 'order_shipped_date',
//       'Out for Delivery': 'out_of_delivery_date',
//       'Delivered': 'delivered_date',
//     };

//     final dateField = statusDateFields[newStatus];
//     if (dateField == null) {
//       print('Invalid status provided.');
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance
//           .collection('ordered_products')
//           .doc(documentId)
//           .update({
//         'status': newStatus,
//         dateField: FieldValue.serverTimestamp(),
//       });
//       print('Status and date updated successfully.');
//     } catch (e) {
//       print('Failed to update status and date: $e');
//     }
//   }

//   /// Firestore stream with optional status filter
//   Stream<QuerySnapshot> _getProductStream() {
//     Query query = FirebaseFirestore.instance
//         .collection('ordered_products')
//         .where('shopId', isEqualTo: shopId);

//     if (statusFilter != null && statusFilter!.isNotEmpty) {
//       query = query.where('status', isEqualTo: statusFilter);
//     }

//     return query.snapshots();
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'Available':
//         return primaryColor;
//       case 'Packed':
//         return Colors.orange;
//       case 'Confirmed':
//         return Colors.blue;
//       case 'Delivered':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
// }

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ShopDetailPage extends StatefulWidget {
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
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  String selectedCategory = "";

  final List<Map<String, dynamic>> steps = [
    {
      'status': 'Confirmed',
      'date': 'order_confirmed_date',
    },
    {
      'status': 'Shipped',
      'date': 'order_shipped_date',
    },
    {
      'status': 'Out for Delivery',
      'date': 'out_of_delivery_date',
    },
    {
      'status': 'Delivered',
      'date': 'delivered_date',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getProductStream(),
        builder: (context, snapshot) {
          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return customLoading();
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Check if data exists
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  if (widget.statusFilter != null)
                    Text(
                      'for status: ${widget.statusFilter}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                ],
              ),
            );
          }

          final orderDocs = snapshot.data!.docs;
          print('Found ${orderDocs.length} documents'); // Debug log

          // Convert documents to ProductModel list
          final recentProducts = <ProductModel>[];
          for (var doc in orderDocs) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              final product = ProductModel.fromMap(data, doc.id);
              recentProducts.add(product);
            } catch (e) {
              print('Error parsing document ${doc.id}: $e');
              // Continue with other documents instead of failing completely
            }
          }

          if (recentProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Failed to parse product data'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Trigger rebuild to refresh data
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics:
                    AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh even with few items
                itemCount: recentProducts.length,
                itemBuilder: (context, index) {
                  final product = recentProducts[index];
                  final orderData =
                      orderDocs[index].data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _showProductDetailsDialog(
                            context, product, orderData, orderDocs[index].id),
                        child: ShopCards(
                          bottomData: Text(
                            'Ordered: ${dateFormatter(product.createdAt)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          actualPrice: product.price.toString(),
                          productQuantity:
                              (orderData['quantity'] ?? product.stocksLeft)
                                  .toString(),
                          deliveryDate: dateFormatter(product.createdAt),
                          productImage: product.productImage,
                          productName: product.productName,
                          productPrice:
                              (orderData['totalPrice'] ?? product.discountPrice)
                                  .toString(),
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
            ),
          );
        },
      ),
    );
  }

  void _showProductDetailsDialog(BuildContext context, ProductModel product,
      Map<String, dynamic> orderData, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            insetPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              // Make dialog scrollable
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 1.5, color: Colors.grey)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.productImage ??
                                  'https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg',
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontFamily: 'Poppins'),
                                      children: [
                                    TextSpan(
                                        text: 'Status | ',
                                        style: TextStyle(color: Colors.grey)),
                                    TextSpan(
                                        text:
                                            '${orderData['status'] ?? product.productStatus}',
                                        style: TextStyle(
                                            color: _getStatusColor(
                                                product.productStatus ?? ''))),
                                  ])),
                              SizedBox(height: 8),
                              Text(
                                '${orderData['productName'] ?? product.productName} (${orderData['quantity'] ?? 1})',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '₹${orderData['totalPrice'] ?? product.discountPrice}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  if (orderData['price'] != null ||
                                      product.price != null)
                                    Text(
                                      '₹${orderData['price'] ?? product.price}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.red),
                                    ),
                                ],
                              ),
                            ],
                          ))
                    ]),
                    SizedBox(height: 15),
                    _buildDetailRow(
                        'User Name', orderData['orderer_name'] ?? 'N/A'),
                    _buildDetailRow('Location', orderData['location'] ?? 'N/A'),
                    _buildDetailRow(
                        'Quantity', '${orderData['quantity'] ?? 1}'),
                    _buildDetailRow(
                        'Order Date', dateFormatter(product.createdAt)),
                    SizedBox(height: 10),
                    Text('Status',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    _buildStatusSelector(context, orderData, docId),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 2),
          buildLabel(value),
        ],
      ),
    );
  }

  Widget _buildStatusSelector(
      BuildContext context, Map<String, dynamic> orderData, String docId) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1.5, color: Colors.grey)]),
        child: ListTile(
            onTap: () => _showStatusSelectionDialog(context, docId),
            title: Text('${orderData['status'] ?? 'Unknown'}'),
            trailing: Icon(Icons.keyboard_arrow_down_rounded)));
  }

  void _showStatusSelectionDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomSpecificationsDialog(
              headerItems: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Text(
                  'Select Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              context: context,
              children: List.generate(steps.length, (index) {
                String item = steps[index]['status'];
                bool isSelected = selectedCategory == item;
                return Column(
                  children: [
                    const Divider(),
                    ListTile(
                      title: Text(
                        item,
                        style: TextStyle(color: _getStatusColor(item)),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                      ),
                      onTap: () {
                        setStateDialog(() {
                          selectedCategory = item;
                        });
                      },
                    ),
                  ],
                );
              }),
              actionButton: MaterialButton(
                height: 60,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                minWidth: double.infinity,
                color: Colors.blue[500],
                onPressed: () async {
                  Navigator.pop(context);
                  if (selectedCategory.isNotEmpty) {
                    await updateOrderStatusAndDate(
                      documentId: documentId,
                      newStatus: selectedCategory,
                    );
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateOrderStatusAndDate({
    required String documentId,
    required String newStatus,
  }) async {
    final statusDateFields = {
      'Confirmed': 'order_confirmed_date',
      'Shipped': 'order_shipped_date',
      'Out for Delivery': 'out_of_delivery_date',
      'Delivered': 'delivered_date',
    };

    final dateField = statusDateFields[newStatus];
    if (dateField == null) {
      print('Invalid status provided: $newStatus');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('ordered_products')
          .doc(documentId)
          .update({
        'status': newStatus,
        dateField: FieldValue.serverTimestamp(),
      });
      print('Status and date updated successfully.');

      // Show success message
      if (mounted) {
        Navigator.pop(context);
        CustomSnackBar.show(
            context: context,
            message: 'Status updated to $newStatus',
            color: Colors.green);
      }
    } catch (e) {
      print('Failed to update status and date: $e');

      // Show error message
      if (mounted) {
        CustomSnackBar.show(
            context: context,
            message: 'Failed to update status: $e',
            color: Colors.red);
      }
    }
  }

  /// Firestore stream with optional status filter
  Stream<QuerySnapshot> _getProductStream() {
    Query query = FirebaseFirestore.instance
        .collection('ordered_products')
        .where('shopId', isEqualTo: widget.shopId);
    //  d ordering for consistent results

    if (widget.statusFilter != null && widget.statusFilter!.isNotEmpty) {
      query = query.where('status', isEqualTo: widget.statusFilter);
    }

    return query.snapshots();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return primaryColor;
      case 'packed':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'out for delivery':
        return Colors.amber;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
