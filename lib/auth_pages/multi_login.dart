import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/mechanic/view/auth/create_account/professional_details_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_home_page.dart';
import 'package:mini_project_1/shop/screens/shop_home.dart';
import 'package:mini_project_1/shop/screens/shop_navbar_page.dart';
import 'package:mini_project_1/user/view/screens/user_navbar_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_navbar_page.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:mini_project_1/utils/messages.dart';

class MultiLoginPage extends StatefulWidget {
  @override
  _MultiLoginPageState createState() => _MultiLoginPageState();
}

class _MultiLoginPageState extends State<MultiLoginPage> {
  final authService = FirebaseAuthServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final uid = FirebaseAuth.instance.currentUser?.uid;

  void login() async {
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context);

      final error = await authService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context);

      if (error == null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) {
          CustomSnackBar.show(
            context: context,
            message: "User ID not found after login.",
            icon: Icons.error,
          );
          return;
        }

        final role = await authService.getUserRole(uid);

        if (role == 'Mechanic') {
          final doc = await FirebaseFirestore.instance
              .collection('mechanics')
              .doc(uid)
              .get();

          final isProfessionalDataCompleted =
              doc.exists && doc.data()?['professionalDataCompleted'] == true;
          print(
              "professionalDataCompleted: ${doc.data()?['professionalDataCompleted']}");

          if (isProfessionalDataCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MechanicNavbarPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProfessionalDetailsPage()),
            );
          }
        } else if (role == 'Shop') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ShopNavbarPage()));
        } else if (role == 'User') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UserNavPage()));
        } else {
          CustomSnackBar.show(
            context: context,
            message: "Unknown or missing role. Contact admin.",
            icon: Icons.warning_amber_rounded,
          );
        }

        CustomSnackBar.show(
          context: context,
          message: 'Login Successful',
          icon: Icons.check_circle_outline_rounded,
          color: Colors.green,
        );
      } else {
        CustomSnackBar.show(
          context: context,
          message: error,
          icon: Icons.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                        tag: 'tow',
                        key: GlobalKey(),
                        child: Image.asset(
                          'assets/icons/tow.png',
                          width: 140,
                        )),
                    Column(
                      children: [
                        Text(
                          "Sign in",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Hi, Welcome back, you’ve been missed",
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Mobile or E-mail",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          keyBoardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email to continue';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          text: 'Enter your Mobile or E-Mail',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          keyBoardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your password to continue';
                            }
                            final passwordRegex = RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
                            if (!passwordRegex.hasMatch(value.trim())) {
                              return '${value.length > 8 ? '✔️' : '✖️'} Password must be at least 8 characters\n${value.contains(RegExp(r'[A-Z]')) ? '✔️' : '✖️'}Include upper/lowercase letters\n${value.contains(RegExp(r'(\d)([\W_])')) ? '✔️' : '✖️'}Number, and special character';
                            }
                            return null;
                          },
                          text: 'Enter your Password',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: primaryColor,
                                fontSize: 14,
                                color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                    CustomMaterialButtom(
                        onPressed: login, buttonText: 'Sign in'),
                    CustomRickText(
                        firstText: 'Don’t have an account? ',
                        secondText: 'Sign Up',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiRoleRegisterPage(),
                              ));
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
