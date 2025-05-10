import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/profile/terms_and_co.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/mechanic/view/auth/create_account/professional_details_page.dart';
import 'package:mini_project_1/common_screens/profile_details.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/user/view/screens/user_notification.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No user data found'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        if (userData == null) {
          return const Center(child: Text('User data is null'));
        }
        List<Map<String, dynamic>> profileData = [
          {
            'title': 'User Details',
            'leading': 'assets/nav_icons/person_unselected.png',
            'trialing': const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            'page': (context) => ProfileDetails(
                  name: userData['name'] ?? 'No Name',
                  email: userData['email'] ?? 'No Email',
                  profileUrl: userData['profileUrl'],
                  phone: userData['mobile'] ?? '',
                  location: userData['location'] ?? 'No Location',
                ),
          },
          {
            'title': 'My Orders',
            'leading': 'assets/nav_icons/shop_unselected.png',
            'trialing': const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            'page': (context) => ProfessionalDetailsPage(),
          },
          {
            'title': 'Notifications',
            'leading': 'assets/profile_icons/notification_profile.png',
            'trialing': const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            'page': (context) => Scaffold(
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          CustomBackButton(),
                          SizedBox(height: 10),
                          UserNotification(),
                        ],
                      ),
                    ),
                  ),
                ),
          },
          {
            'title': 'Terms and policy',
            'leading': 'assets/profile_icons/security_profile.png',
            'trialing': const Icon(Icons.error, size: 0),
            'page': (context) => const TermsAndCo(),
          },
        ];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userData['profileUrl'] != null
                        ? NetworkImage(userData['profileUrl'])
                        : AssetImage(
                            'mini_project_1/assets/images/error_image.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userData['name'] ?? 'No Name',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                userData['email'] ?? 'No Email',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(profileData.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: profileData[index]['page']),
                      );
                    },
                    child: ProfileCards(
                      profileData[index]['trialing'],
                      image: profileData[index]['leading'],
                      title: profileData[index]['title'],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MultiRoleRegisterPage()),
                    (route) => false,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.025),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 6,
                      ),
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
                      title:
                          Text('Logout', style: TextStyle(color: Colors.red)),
                      leading: ImageIcon(
                        AssetImage('assets/icons/logout.png'),
                        size: 30,
                      ),
                    ),
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
