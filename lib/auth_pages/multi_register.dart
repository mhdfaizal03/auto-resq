import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/mechanic/view/auth/create_account/professional_details_page.dart';
import 'package:mini_project_1/shop/screens/shop_home.dart';
import 'package:mini_project_1/shop/screens/shop_navbar_page.dart';
import 'package:mini_project_1/user/view/screens/user_home_page.dart';
import 'package:mini_project_1/user/view/screens/user_navbar_page.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MultiRoleRegisterPage extends StatefulWidget {
  const MultiRoleRegisterPage({super.key});

  @override
  State<MultiRoleRegisterPage> createState() => _MultiRoleRegisterPageState();
}

class _MultiRoleRegisterPageState extends State<MultiRoleRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = FirebaseAuthServices();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedRole = 'User';
  final roles = ['User', 'Mechanic', 'Shop'];

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Column(
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    textAlign: TextAlign.center,
                    'Fill your information below or register with your social account',
                  ),
                ],
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedRole,
                autofocus: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 10),
              buildLabel('Full Name'),
              CustomTextField(
                text: 'Enter your Full Name',
                controller: nameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 10),
              buildLabel('Mobile Number'),
              CustomTextField(
                keyBoardType: TextInputType.phone,
                text: 'Enter your Mobile',
                controller: mobileController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                    return 'Enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildLabel('Email'),
              CustomTextField(
                keyBoardType: TextInputType.emailAddress,
                text: 'Enter your E-Mail',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildLabel('Location'),
              CustomTextField(
                text: 'Enter your Location',
                controller: locationController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Location is required'
                    : null,
              ),
              const SizedBox(height: 10),
              buildLabel('Password'),
              CustomTextField(
                keyBoardType: TextInputType.visiblePassword,
                text: 'Enter your Password',
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Password is required';
                  final regex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
                  if (!regex.hasMatch(value.trim())) {
                    return 'Password must be 8+ characters with upper/lowercase, number & special char';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildLabel('Confirm Password'),
              CustomTextField(
                text: 'Re-enter your Password',
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              CustomMaterialButtom(
                buttonText: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showLoadingDialog(context);

                    final error = await _authService.registerUser(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      mobile: mobileController.text.trim(),
                      location: locationController.text.trim(),
                      role: selectedRole,
                    );

                    Navigator.pop(context);

                    if (error == null) {
                      if (selectedRole == 'Mechanic') {
                        // await FirebaseFirestore.instance
                        //     .collection('mechanics')
                        //     .doc(user)
                        //     .update({
                        //   'uid': user,
                        //   'professionalDataCompleted': false,
                        //   'timestamp': FieldValue.serverTimestamp(),
                        // });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MultiLoginPage()),
                        );
                      } else if (selectedRole == 'Shop') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ShopNavbarPage()),
                        );
                      } else if (selectedRole == 'User') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => UserNavPage()),
                        );
                      }
                    } else {
                      CustomSnackBar.show(
                        context: context,
                        message: error,
                        icon: Icons.warning_amber_rounded,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: CustomRickText(
                  firstText: 'Already have an account? ',
                  secondText: 'Sign In',
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiLoginPage(),
                    ),
                    (route) => false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
