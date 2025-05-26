import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product['productImage'] ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel(product['productName'] ?? 'Product Name'),
                      Text(
                        product['brandName'] ?? '',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product['stocksLeft'] ?? '0'} Stocks Left',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Free Delivery',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '₹${product['discountPrice'] ?? '0'}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  if (product['price'] != null)
                    Text(
                      '₹${product['price']}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decorationColor: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              buildLabel('Description'),
              const SizedBox(height: 5),
              Text(
                product['productDescription'] ??
                    'No description available for this product.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              buildLabel('Specifications'),
              const SizedBox(height: 5),
              Text(
                product['productSpecification'] ??
                    'No specifications provided for this product.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
            height: 50,
            child:
                CustomMaterialButtom(onPressed: () {}, buttonText: 'Buy Now')),
      ),
    );
  }
}
