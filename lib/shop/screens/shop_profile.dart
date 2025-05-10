import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/profile/profile_screen.dart'
    as mechanic_profile;
import 'package:mini_project_1/admin/view/profile/terms_and_co.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/common_screens/profile_details.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/mechanic/view/auth/create_account/professional_details_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_navbar_page.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/mechanic/view/screens/professional_details_edit_page.dart';
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
  Future<Map<String, dynamic>?> getMechanicData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('shops').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'Mechanic Details',
      'leading': 'assets/nav_icons/person_unselected.png',
      'route': true,
    },
    {
      'title': 'Professional Details',
      'leading': 'assets/nav_icons/professional_details.png',
      'page': (context) => ProfessionalDetailsEditPage(),
      'route': true,
    },
    {
      'title': 'Notifications',
      'leading': 'assets/profile_icons/notification_profile.png',
      'page': (context) => MechanicNavbarPage(selectedIndex: 1),
      'route': false,
    },
    {
      'title': 'Terms and policy',
      'leading': 'assets/profile_icons/security_profile.png',
      'page': (context) => TermsAndCo(),
      'route': true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getMechanicData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: mq.width * 0.15,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 30),
                  ...List.generate(
                      3,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Profile not found"));
        }

        final mechanic = snapshot.data!;
        final name = mechanic['name'] ?? 'No Name';
        final email = mechanic['email'] ?? 'No Email';
        final phone = mechanic['phone'] ?? '';
        final location = mechanic['location'] ?? '';
        final profileUrl = mechanic['profileUrl'] ??
            'https://cdn-icons-png.flaticon.com/512/149/149071.png';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'profile',
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: mq.width * 0.15,
                backgroundImage: NetworkImage(profileUrl),
              ),
            ),
            SizedBox(height: 20),
            Text(name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(email, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Column(
              children: List.generate(profileOptions.length, (index) {
                final item = profileOptions[index];
                return InkWell(
                  onTap: () {
                    if (item['title'] == 'Mechanic Details') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileDetails(
                            name: name,
                            email: email,
                            phone: phone,
                            location: location,
                            profileUrl: profileUrl,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: item['page']),
                        (route) => item['route'],
                      );
                    }
                  },
                  child: mechanic_profile.ProfileCards(
                    Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    image: item['leading'],
                    title: item['title'],
                  ),
                );
              }),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MultiRoleRegisterPage()),
                  (route) => false,
                );
              },
              child: Container(
                height: mq.height * 0.07,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq.width * 0.025),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5), blurRadius: 6)
                  ],
                  color: Colors.white,
                ),
                child: Center(
                  child: ListTile(
                    onTap: () {
                      customAlertWidget(
                          context: context,
                          content: Text('Are you sure want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                customLoading();
                                FirebaseAuthServices().logoutUser();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiLoginPage(),
                                  ),
                                  (route) => false,
                                );

                                CustomSnackBar.show(
                                    context: context,
                                    message: 'Logged out successfully',
                                    color: Colors.green,
                                    icon: Icons.check_circle_rounded);
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]);
                    },
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    leading: Image.asset('assets/icons/logout.png', width: 30),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
