import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/screens/product_details_screen.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ShopHome extends StatelessWidget {
  ShopHome({super.key});

  final List<Map<String, dynamic>> datas = [
    {
      "number": 121,
      "detailName": "Total Products",
      "color": Colors.blue,
      "products": List.generate(
          5,
          (i) => {
                "quantity": 3,
                "date": "22/05/2025",
                "image":
                    "https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg",
                "name": "Product TP-$i",
                "price": "500",
                "status": "Available",
                "statusColor": Colors.green,
              })
    },
    {
      "number": 21,
      "detailName": "Packed Products",
      "color": Colors.red,
      "products": List.generate(
          3,
          (i) => {
                "quantity": 2,
                "date": "21/05/2025",
                "image":
                    "https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg",
                "name": "Packed Product $i",
                "price": "350",
                "status": "Packed",
                "statusColor": Colors.orange,
              })
    },
    {
      "number": 21,
      "detailName": "Confirmed Products",
      "color": Colors.amber,
      "products": List.generate(
          4,
          (i) => {
                "quantity": 1,
                "date": "23/05/2025",
                "image":
                    "https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg",
                "name": "Confirmed Product $i",
                "price": "620",
                "status": "Confirmed",
                "statusColor": Colors.blue,
              })
    },
    {
      "number": 21,
      "detailName": "Delivered Orders",
      "color": Colors.green,
      "products": List.generate(
          2,
          (i) => {
                "quantity": 1,
                "date": "20/05/2025",
                "image":
                    "https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg",
                "name": "Delivered Product $i",
                "price": "700",
                "status": "Delivered",
                "statusColor": Colors.green,
              })
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          itemCount: datas.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            final item = datas[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShopDetailPage(
                      title: item['detailName'],
                      products: item['products'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 1.5, color: Colors.grey)
                    ]),
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
                            boxShadow: [
                              BoxShadow(blurRadius: 1.5, color: Colors.grey)
                            ]),
                        child: Center(
                          child: Text(
                            item['number'].toString(),
                            style: TextStyle(
                                color: item['color'],
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item['detailName'].toString(),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Recent Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ShopCards(
                  productQuantity: 2.toString(),
                  deliveryDate: '22/03/2025',
                  productImage:
                      'https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg',
                  productName: 'Product 1',
                  productPrice: '887',
                  deliveryStatus: 'Pending',
                  deliveryStatusColor: Colors.orange,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
