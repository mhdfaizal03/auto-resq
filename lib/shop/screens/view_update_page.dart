import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/shop/models/model/product_model.dart';
import 'package:mini_project_1/shop/models/services/shop_firebase_services.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ViewUpdatePage extends StatefulWidget {
  ProductModel product;
  ViewUpdatePage({super.key, required this.product});

  @override
  State<ViewUpdatePage> createState() => _ViewUpdatePageState();
}

class _ViewUpdatePageState extends State<ViewUpdatePage> {
  final List<String> categories = [
    "All",
    "Emergency Tool",
    "Battery & Electrical",
    "Exterior & Interior",
    "Mechanical Parts",
    "Safety & Security",
    "Cleaning & Maintainance"
  ];

  String? selectedCategory;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController specificationController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  FirebaseProductService _productServices = FirebaseProductService();

  bool isEditRead = true;

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.productName!;
    brandNameController.text = widget.product.brandName!;
    categoryController.text = widget.product.productCategory!;
    priceController.text = widget.product.price.toString();
    discountPriceController.text = widget.product.discountPrice.toString();
    stockController.text = widget.product.stocksLeft.toString();
    descriptionController.text = widget.product.productDescription!;
    specificationController.text = widget.product.productSpecification!;
    imageController.text = widget.product.productImage!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(),
                  const SizedBox(height: 20),
                  buildLabel('Product Name'),
                  CustomTextField(
                    readOnly: isEditRead,
                    text: 'Enter Product Name',
                    controller: productNameController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Product name is required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Brand Name'),
                  CustomTextField(
                    readOnly: isEditRead,
                    text: 'Enter Product Brand Name',
                    controller: brandNameController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Brand name is required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Category'),
                  CustomTextField(
                    readOnly: true,
                    controller: categoryController,
                    text: 'Select Category',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Category is required'
                        : null,
                    suffix: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      onPressed: () => _showCategoryDialog(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel('Price'),
                            CustomTextField(
                              readOnly: isEditRead,
                              text: 'Rs.100',
                              controller: priceController,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Price required';
                                final parsed = double.tryParse(val);
                                if (parsed == null || parsed <= 0)
                                  return 'Enter valid price';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel('Discount Price'),
                            CustomTextField(
                              readOnly: isEditRead,
                              text: 'Rs.90',
                              controller: discountPriceController,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Discount required';
                                try {
                                  final price =
                                      double.tryParse(priceController.text) ??
                                          0;
                                  final discount = double.parse(val);
                                  if (discount >= price)
                                    return 'Must be < price';
                                } catch (e) {
                                  return 'Enter valid discount';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Stocks Left'),
                  SizedBox(
                    width: 100,
                    child: CustomTextField(
                      readOnly: isEditRead,
                      text: '00.0 pcs.',
                      controller: stockController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Stock required' : null,
                    ),
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Product Description'),
                  CustomTextField(
                    readOnly: isEditRead,
                    maxLines: 5,
                    text: 'Enter product description',
                    controller: descriptionController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Description required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Product Specifications'),
                  CustomTextField(
                    readOnly: isEditRead,
                    maxLines: 5,
                    text: 'Enter product specifications',
                    controller: specificationController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Specifications required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  buildLabel('Add Product Image'),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: CustomTextField(
                          readOnly: true,
                          text: 'Add product image',
                          controller: imageController,
                          validator: (val) => null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: CustomMaterialButtom(
                          onPressed: () {
                            // TODO: Implement image picker
                          },
                          buttonText: 'Add',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomMaterialButtom(
                          color: Colors.red,
                          onPressed: () async {
                            try {
                              await _productServices.deleteProduct(
                                widget.product.productId.toString(),
                              );
                              Navigator.pop(context);
                              CustomSnackBar.show(
                                context: context,
                                message: 'Product deleted successfully',
                                color: Colors.red,
                                icon: Icons.delete_outline,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  message: 'Delete failed: ${e.toString()}',
                                  context: context,
                                  color: Colors.red,
                                  icon: Icons.error_outline,
                                );
                              }
                            }
                          },
                          buttonText: 'Delete Product',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomMaterialButtom(
                          onPressed: () async {
                            if (isEditRead) {
                              setState(() {
                                isEditRead = false;
                              });
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              try {
                                final shopId =
                                    FirebaseAuth.instance.currentUser!.uid;

                                await _productServices.updateProduct(
                                  widget.product.productId.toString(),
                                  ProductModel(
                                    productId: widget.product.productId,
                                    brandName: brandNameController.text,
                                    productName: productNameController.text,
                                    productDescription:
                                        descriptionController.text,
                                    productCategory: categoryController.text,
                                    productSpecification:
                                        specificationController.text,
                                    productStatus: 'Pending',
                                    productImage: imageController.text,
                                    price: double.parse(priceController.text),
                                    discountPrice: double.parse(
                                        discountPriceController.text),
                                    stocksLeft: int.parse(stockController.text),
                                    shopId: shopId,
                                  ),
                                );

                                Navigator.pop(context);
                                CustomSnackBar.show(
                                  context: context,
                                  message: 'Product updated successfully',
                                  color: Colors.green,
                                  icon: Icons.check_circle_outline,
                                );
                              } catch (e) {
                                if (context.mounted) {
                                  CustomSnackBar.show(
                                    message: 'Update failed: ${e.toString()}',
                                    context: context,
                                    color: Colors.red,
                                    icon: Icons.error_outline,
                                  );
                                }
                              }
                            }
                          },
                          buttonText:
                              isEditRead ? 'Edit Product' : 'Save Product',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomSpecificationsDialog(
              headerItems: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Text(
                  'Select Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              context: context,
              children: List.generate(categories.length, (index) {
                String item = categories[index];
                bool isSelected = selectedCategory == item;
                return Column(
                  children: [
                    const Divider(),
                    ListTile(
                      title: Text(item),
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
                onPressed: () {
                  setState(() {
                    categoryController.text = selectedCategory ?? '';
                  });
                  Navigator.pop(context);
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
}
