import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/admin/models/services/admin_firebase_services.dart';
import 'package:mini_project_1/admin/view/profile/mechanic_requests.dart';
import 'package:mini_project_1/admin/view/profile/terms_and_co.dart';
import 'package:mini_project_1/admin/view/auth/login_screen.dart';
import 'package:mini_project_1/admin/view/screens/home/admin_navbar_screen.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AdminFirebaseService _firebaseService = AdminFirebaseService();
  late Future<Map<String, dynamic>?> profileFuture;

  final List<Map<String, dynamic>> profileData = [
    {
      'title': 'Mechanic Requests',
      'leading': 'assets/profile_icons/people_profile.png',
      'trialing': Icon(Icons.arrow_forward_ios_rounded, size: 18),
      'page': (context) => const MechanicRequests(),
      'route': true,
    },
    {
      'title': 'Notifications',
      'leading': 'assets/profile_icons/notification_profile.png',
      'trialing': Icon(Icons.arrow_forward_ios_rounded, size: 18),
      'page': (context) => AdminNavbarScreen(selectedIndex: 2),
      'route': false,
    },
    {
      'title': 'Terms and policy',
      'leading': 'assets/profile_icons/security_profile.png',
      'trialing': Icon(Icons.error, size: 0),
      'page': (context) => const TermsAndCo(),
      'route': true,
    }
  ];

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    profileFuture = _firebaseService.getAdminProfile(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildShimmerProfileUI();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No profile data found.'));
            }

            final data = snapshot.data!;
            return _buildProfileUI(context, data);
          },
        ),
      ),
    );
  }

  Widget _buildProfileUI(BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios, size: mq.width * 0.050),
                  Text('Back',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mq.width * 0.050)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Hero(
            tag: 'profile',
            child: CircleAvatar(
              radius: mq.width * 0.15,
              backgroundImage: NetworkImage(data['profileImageUrl'] ??
                  'https://via.placeholder.com/150'), // fallback image
            ),
          ),
          const SizedBox(height: 30),
          Text(data['name'] ?? 'No Name',
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(data['role'] ?? 'Admin', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 30),
          Column(
            children: List.generate(
              profileData.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            profileData[index]['page'](context)),
                    (route) => profileData[index]['route'],
                  );
                },
                child: ProfileCards(
                  profileData[index]['trialing'],
                  image: profileData[index]['leading'],
                  title: profileData[index]['title'],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          InkWell(
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
            child: Container(
              height: mq.height * 0.070,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mq.width * 0.025),
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
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                  leading: Image.asset('assets/icons/logout.png', width: 30),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text('Version 2.343.3'),
        ],
      ),
    );
  }
}

class ProfileCards extends StatelessWidget {
  final String title;
  final String image;
  final Widget trialingIcon;

  const ProfileCards(
    this.trialingIcon, {
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.068,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
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
          title: Text(title),
          leading: Image.asset(image, width: 30),
          trailing: trialingIcon,
        ),
      ),
    );
  }
}
