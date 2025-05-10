import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/auth_pages/multi_login.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ProfileDetails extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? profileUrl;

  const ProfileDetails({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.profileUrl,
  });

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  bool isEdit = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
    mobileController.text = widget.phone;
    locationController.text = widget.location;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left),
                        Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 45,
                        backgroundImage: widget.profileUrl != null
                            ? NetworkImage(widget.profileUrl!)
                            : null,
                        child: widget.profileUrl == null
                            ? Icon(Icons.person, size: 45, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.email),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildLabel('Name'),
                  SizedBox(height: 5),
                  CustomTextField(
                    readOnly: isEdit,
                    text: 'Name',
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  buildLabel('Mobile Number'),
                  SizedBox(height: 5),
                  CustomTextField(
                    readOnly: isEdit,
                    text: 'Mobile Number',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Mobile number cannot be empty';
                      } else if (value.length < 10) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                    controller: mobileController,
                  ),
                  SizedBox(height: 20),
                  buildLabel('E- Mail'),
                  SizedBox(height: 5),
                  CustomTextField(
                    readOnly: isEdit,
                    text: 'E- Mail',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email cannot be empty';
                      } else if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  buildLabel('Location'),
                  SizedBox(height: 5),
                  CustomTextField(
                    readOnly: isEdit,
                    text: 'Enter location',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Location cannot be empty';
                      }
                      return null;
                    },
                    controller: locationController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  customAlertWidget(
                    context: context,
                    content: buildLabel('Do you want to delete your account'),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiLoginPage(),
                            ),
                            (route) => false,
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: CupertinoAlertDialog(
                                  content: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                          size: 80,
                                        ),
                                        Text(
                                          "Account Deleted",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (!isEdit) {
                    if (_formKey.currentState!.validate()) {
                      customAlertWidget(
                        context: context,
                        content: buildLabel(
                            'Do you sure you want to update your profile details?'),
                        actions: [
                          MaterialButton(
                            onPressed: () async {
                              Navigator.pop(context); // close dialog
                              await FirebaseFirestoreServices()
                                  .updateMechanicDetails(
                                name: nameController.text,
                                email: emailController.text,
                                phone: mobileController.text,
                                location: locationController.text,
                                profileUrl: widget.profileUrl.toString(),
                              );
                              CustomSnackBar.show(
                                  message: 'Profile Updated',
                                  context: context,
                                  color: Colors.green,
                                  icon: Icons.check_circle_rounded);
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    setState(() {
                      isEdit = false;
                    });
                  }
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      isEdit ? 'Edit' : 'Update',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
