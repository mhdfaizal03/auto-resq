import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/all_auth_services/model/user_create_request_model.dart';
import 'package:mini_project_1/all_auth_services/firebase_auth_services.dart';
import 'package:mini_project_1/user/view/screens/user_home_page.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class UserCreateRequestsPage extends StatefulWidget {
  const UserCreateRequestsPage({super.key});

  @override
  State<UserCreateRequestsPage> createState() => _UserCreateRequestsPageState();
}

class _UserCreateRequestsPageState extends State<UserCreateRequestsPage> {
  final List<String> specifications = [
    "Engine Repair",
    "Brake System Repair",
    "Transmission Services",
    "Electrical System Repair",
    "Suspension & Steering",
    "Air Conditioning & Heating",
    "Tyre & Wheel Services",
    "Battery & Charging System",
    "Hybrid & EV Maintenance",
  ];

  List<String> selectedItems = [];
  final _firebaseServices = FirebaseFirestoreServices();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedItems.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: 'Please select at least one specialization',
        color: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    if (user == null) {
      CustomSnackBar.show(
        context: context,
        message: 'User not logged in',
        color: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final userData = doc.data();
      final userName = userData?['name'] ?? 'Unknown';

      final request = UserCreateRequestModel(
        amount: "",
        workshopName: "",
        userName: userName,
        status: 'Pending',
        date: formatDate(DateTime.now()),
        time: formatTime(DateTime.now()),
        place: locationController.text.trim(),
        phoneNo: phoneController.text.trim(),
        services: selectedItems,
        assignedMechanicName: "",
        issueText: descriptionController.text.trim(),
        location: locationController.text.trim(),
        isPaid: false,
        id: user!.uid,
        description: descriptionController.text,
        userEmail: user!.email.toString(),
      );

      showLoadingDialog(context);
      await _firebaseServices.submitMechanicRequest(request);
      Navigator.pop(context);
      CustomSnackBar.show(
        context: context,
        message: 'Request submitted successfully!',
        color: Colors.green,
        icon: Icons.check_circle,
      );
      clearForm();
    } catch (e) {
      Navigator.pop(context);
      CustomSnackBar.show(
        context: context,
        message: 'Failed to submit request: ${e.toString()}',
        color: Colors.red,
        icon: Icons.error_outline,
      );
    }
  }

  void clearForm() {
    phoneController.clear();
    locationController.clear();
    descriptionController.clear();
    specializationController.clear();
    selectedItems.clear();
    setState(() {});
  }

  void updateSpecializationController() {
    specializationController.text = selectedItems.isEmpty
        ? 'Select Specializations'
        : '${selectedItems.length} Specializations selected';
  }

  // void getMobileNo() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;

  //   final doc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .get();

  //   if (doc.exists) {
  //     final data = doc.data();
  //     if (data != null && data['phone'] != null) {
  //       phoneController.text = data['phone'];
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    updateSpecializationController();
    // getMobileNo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: MaterialButton(
          height: 50,
          color: primaryColor,
          minWidth: double.infinity,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: submitRequest,
          child: const Text('Book Now', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomBackButton(),
                  const SizedBox(height: 10),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text("User info not found");
                      }
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Row(
                        children: [
                          CircleAvatar(
                              radius: 45, backgroundColor: Colors.grey[200]),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? 'Guest',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(data['email'] ?? 'No email'),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  buildLabel('Mobile Number'),
                  const SizedBox(height: 5),
                  CustomTextField(
                    keyBoardType: TextInputType.phone,
                    controller: phoneController,
                    text: 'Enter your phone no here',
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Please enter your phone number';
                      if (val.length < 10) return 'Enter a valid phone number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  buildLabel('Your location'),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: locationController,
                    maxLines: 2,
                    text:
                        'Enter the location where your vehicle is stuck or broken down.',
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Please enter your location';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  buildLabel('Issue Type'),
                  const SizedBox(height: 5),
                  CustomTextField(
                    readOnly: true,
                    controller: specializationController,
                    text: '',
                    validator: (_) => null,
                    suffix: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, localSetState) {
                                return CustomSpecificationsDialog(
                                  headerItems: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Select Specializations',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  context: context,
                                  children: List.generate(specifications.length,
                                      (index) {
                                    final item = specifications[index];
                                    final isSelected =
                                        selectedItems.contains(item);

                                    return Column(
                                      children: [
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: InkWell(
                                            onTap: () {
                                              localSetState(() {
                                                if (isSelected) {
                                                  selectedItems.remove(item);
                                                } else {
                                                  selectedItems.add(item);
                                                }
                                              });
                                              setState(() {
                                                updateSpecializationController();
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text(item)),
                                                  Icon(isSelected
                                                      ? Icons.radio_button_on
                                                      : Icons.radio_button_off),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                      Navigator.pop(context);
                                      updateSpecializationController();
                                    },
                                    child: const Text('Save',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLabel('Additional Details (Optional)'),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: descriptionController,
                    maxLines: 5,
                    text: 'Describe the issue in detail',
                    validator: (_) => null,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
