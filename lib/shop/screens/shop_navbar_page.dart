import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/common_screens/notification_page.dart';
import 'package:mini_project_1/shop/screens/create_products.dart';
import 'package:mini_project_1/shop/screens/products_page.dart';
import 'package:mini_project_1/shop/screens/shop_home.dart';
import 'package:mini_project_1/shop/screens/shop_profile.dart';
import 'package:mini_project_1/utils/colors.dart';

class ShopNavbarPage extends StatefulWidget {
  int? selectedIndex = 0;
  ShopNavbarPage({this.selectedIndex, super.key});

  @override
  State<ShopNavbarPage> createState() => _ShopNavbarPageState();
}

class _ShopNavbarPageState extends State<ShopNavbarPage> {
  late final String? shopId;

  @override
  void initState() {
    super.initState();
    shopId = FirebaseAuth.instance.currentUser?.uid;
  }

  List<Map<String, dynamic>> bottomIcons = [
    {
      'selected': 'assets/nav_icons/orders_selected.png',
      'unselected': 'assets/nav_icons/orders_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/products_selected.png',
      'unselected': 'assets/nav_icons/products_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/notification_selected.png',
      'unselected': 'assets/nav_icons/notification_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/person_selected.png',
      'unselected': 'assets/nav_icons/person_unselected.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (shopId == null) {
      return const Center(
          child: CircularProgressIndicator()); // Or error message
    }

    List<Widget> pages = [
      ShopHome(shopId: shopId!),
      ProductsPage(),
      NotificationPageByRole(role: 'Shop'),
      ShopProfile(),
    ];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.selectedIndex == 1
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProducts(),
                    ),
                  );
                },
                color: primaryColor,
                height: 55,
                minWidth: double.infinity,
                child: const Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(color: primaryColor),
          currentIndex: widget.selectedIndex ?? 0,
          onTap: (value) {
            setState(() {
              widget.selectedIndex = value;
            });
          },
          items: List.generate(
            bottomIcons.length,
            (index) {
              return BottomNavigationBarItem(
                activeIcon: Image.asset(
                  bottomIcons[index]['selected'],
                  width: 30,
                ),
                label: index == 0
                    ? 'Orders'
                    : index == 1
                        ? 'Products'
                        : index == 2
                            ? 'Notifications'
                            : 'Profile',
                icon: Image.asset(
                  bottomIcons[index]['unselected'],
                  width: 30,
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/AutoResQ.png',
                        width: 120,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                pages[widget.selectedIndex ?? 0],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
