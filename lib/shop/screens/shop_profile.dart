import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/profile/profile_screen.dart'
    as mechanic_profile;
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/common_screens/profile_details.dart';
import 'package:mini_project_1/user/view/screens/product_details_page.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:shimmer/shimmer.dart';

class ShopProfile extends StatefulWidget {
  const ShopProfile({super.key});

  @override
  State<ShopProfile> createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'Confirmed Orders',
      'leading': 'assets/icons/check_circle.png',
      'status': 'Confirmed',
    },
    {
      'title': 'Packed Orders',
      'leading': 'assets/icons/packed_orders.png',
      'status': 'Packed',
    },
    {
      'title': 'Delivered Orders',
      'leading': 'assets/icons/delivered_orders.png',
      'status': 'Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('shops').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerProfileUI();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Profile not found"));
        }

        final shop = snapshot.data!.data() as Map<String, dynamic>;

        final name = shop['name'] ?? 'No Name';
        final email = shop['email'] ?? 'No Email';
        final phone = shop['phone'] ?? '';
        final location = shop['location'] ?? '';
        final profileUrl = shop['profileUrl'] ??
            'https://cdn-icons-png.flaticon.com/512/149/149071.png';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'profile',
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profileUrl),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              Text(name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // Order Options
              Column(
                children: List.generate(profileOptions.length, (index) {
                  final item = profileOptions[index];
                  return InkWell(
                    onTap: () async {
                      final querySnapshot = await FirebaseFirestore.instance
                          .collection('ordered_products')
                          .where('shopId', isEqualTo: uid)
                          .where('status', isEqualTo: item['status'])
                          .get();

                      if (querySnapshot.docs.isEmpty) {
                        CustomSnackBar.show(
                          context: context,
                          message: 'No ${item['title']} yet',
                          color: Colors.orange,
                          icon: Icons.info,
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(
                            product: querySnapshot.docs.first.data(),
                          ),
                        ),
                      );
                    },
                    child: ProfileCards(
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      image: item['leading'],
                      title: item['title'],
                    ),
                  );
                }),
              ),

              // Terms & Policy
              InkWell(
                onTap: () {},
                child: ProfileCards(
                  const Icon(Icons.arrow_forward_ios_rounded, size: 0),
                  image: 'assets/profile_icons/security_profile.png',
                  title: 'Terms and policy',
                ),
              ),

              const SizedBox(height: 40),

              // Logout Button
              InkWell(
                onTap: () {
                  customAlertWidget(
                    context: context,
                    content: const Text('Are you sure want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          customLoading();
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => MultiLoginPage()),
                            (route) => false,
                          );
                          CustomSnackBar.show(
                            context: context,
                            message: 'Logged out successfully',
                            color: Colors.green,
                            icon: Icons.check_circle,
                          );
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5), blurRadius: 6),
                    ],
                  ),
                  child: ListTile(
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.red)),
                    leading: Image.asset('assets/icons/logout.png', width: 30),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
