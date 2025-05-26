import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';
import 'package:mini_project_1/shop/models/services/shop_firebase_services.dart';
import 'package:mini_project_1/shop/screens/view_update_page.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<String> filters = [
    "All",
    "Emergency Tool",
    "Battery & Electrical",
    "Exterior & Interior",
    "Mechanical Parts",
    "Safety & Security",
    "Cleaning & Maintainance"
  ];

  int selectedIndex = 0;
  final FirebaseProductService _productService = FirebaseProductService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildLabel('Products'),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(filters.length, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedIndex == index ? primaryColor : Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 1.5, color: Colors.grey),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<List<ProductModel>>(
          stream: _productService.streamAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return customLoading();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allProducts = snapshot.data ?? [];

            final selectedFilter = filters[selectedIndex];
            final filteredProducts = selectedFilter == "All"
                ? allProducts
                : allProducts.where((product) {
                    return product.productCategory?.toLowerCase() ==
                        selectedFilter.toLowerCase();
                  }).toList();

            if (filteredProducts.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewUpdatePage(
                                product: product,
                              ),
                            ));
                      },
                      child: ShopCards(
                        bottomData: Text(
                          'Stocks: ${product.stocksLeft}',
                        ),
                        actualPrice: product.price.toString(),
                        productQuantity: product.stocksLeft?.toString() ?? '0',
                        deliveryDate:
                            product.createdAt?.toString().split(" ").first ??
                                '',
                        productImage: product.productImage ??
                            'https://via.placeholder.com/150',
                        productName: product.productName ?? 'Unnamed',
                        productPrice:
                            '${product.discountPrice?.toStringAsFixed(2) ?? '0.00'}',
                        deliveryStatus: product.productStatus ?? 'Pending',
                        deliveryStatusColor:
                            _getStatusColor(product.productStatus ?? 'Pending'),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
