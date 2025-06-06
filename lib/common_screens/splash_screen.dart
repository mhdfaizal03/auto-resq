import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/screens/home/admin_navbar_screen.dart';

import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/mechanic/view/auth/create_account/professional_details_page.dart';
import 'package:mini_project_1/shop/screens/shop_navbar_page.dart';
import 'package:mini_project_1/user/view/screens/user_navbar_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_navbar_page.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class SplashIconScreen extends StatefulWidget {
  const SplashIconScreen({super.key});

  @override
  State<SplashIconScreen> createState() => _SplashIconScreenState();
}

class _SplashIconScreenState extends State<SplashIconScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => const SplashInnerScreen(),
        ),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Hero(
            tag: 'tow',
            child: Image.asset(
              'assets/icons/tow.png',
              width: 204,
            ),
          ),
        ),
      ),
    );
  }
}

class SplashInnerScreen extends StatefulWidget {
  const SplashInnerScreen({super.key});

  @override
  State<SplashInnerScreen> createState() => _SplashInnerScreenState();
}

class _SplashInnerScreenState extends State<SplashInnerScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  void _navigateUser() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'No internet connection. Please try again.',
        color: Colors.red,
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MultiLoginPage()),
        (route) => false,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (_, __, ___) => MultiLoginPage(),
        ),
        (route) => false,
      );
      return;
    }

    try {
      final uid = user.uid;
      final firestore = FirebaseFirestore.instance;

      final userDoc = await firestore.collection('users').doc(uid).get();
      final mechanicDoc =
          await firestore.collection('mechanics').doc(uid).get();
      final shopDoc = await firestore.collection('shops').doc(uid).get();
      final adminDoc = await firestore.collection('admins').doc(uid).get();

      final userData = userDoc.data();
      final mechanicData = mechanicDoc.data();
      final shopData = shopDoc.data();
      final adminData = adminDoc.data();

      if (userData != null && userData['role'] == 'User') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (_, __, ___) => UserNavPage(),
          ),
          (route) => false,
        );
      } else if (mechanicData != null && mechanicData['role'] == 'Mechanic') {
        final isCompleted = mechanicData['professionalDataCompleted'] ?? false;
        final isAccepted = mechanicData['isAdminAccept'] ?? 0;

        if (isAccepted == 1) {
          if (isCompleted == true) {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1500),
                pageBuilder: (_, __, ___) =>
                    MechanicNavbarPage(selectedIndex: 0),
              ),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1500),
                pageBuilder: (_, __, ___) => ProfessionalDetailsPage(),
              ),
              (route) => false,
            );
          }
        } else if (isAccepted == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MultiLoginPage()),
            (route) => false,
          );
          CustomSnackBar.show(
            context: context,
            message: 'Your request is under pending',
          );
          await Future.delayed(const Duration(seconds: 2));
        } else if (isAccepted == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MultiLoginPage()),
            (route) => false,
          );
          CustomSnackBar.show(
            context: context,
            message:
                'Your request has been rejected by admin due to some reason',
          );
        }
      } else if (shopData != null && shopData['role'] == 'Shop') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (_, __, ___) => ShopNavbarPage(),
          ),
          (route) => false,
        );
      } else if (adminData != null && adminData['role'] == 'Admin') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (_, __, ___) => AdminNavbarScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MultiLoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Role check error: $e');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MultiLoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'tow',
              child: Image.asset(
                'assets/icons/tow.png',
                width: 55,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/icons/AutoResQ.png',
              width: 190,
            ),
          ],
        ),
      ),
    );
  }
}
