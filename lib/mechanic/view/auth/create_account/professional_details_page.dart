import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/all_auth_services/string_images.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/mechanic/models/services/mechanic_firebase_services.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ProfessionalDetailsPage extends StatefulWidget {
  const ProfessionalDetailsPage({super.key});

  @override
  State<ProfessionalDetailsPage> createState() =>
      _ProfessionalDetailsPageState();
}

class _ProfessionalDetailsPageState extends State<ProfessionalDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController workshopNameController = TextEditingController();
  final TextEditingController workshopAddressController =
      TextEditingController();
  final TextEditingController idProofController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();

  int? selectedIndex;
  List<String> experience = ["0-2 Year", "2-5 Year", "5+ Year"];

  List<String> specifications = [
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

  Uint8List? profileImageBytes;

  Future<void> _pickProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        profileImageBytes = result.files.single.bytes!;
      });
    }
  }

  Future<void> _pickIDProof() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        idProofController.text = result.files.single.name;
      });
    }
  }

  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Professional Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter your works and workshop details for verification.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profileImageBytes != null
                              ? MemoryImage(profileImageBytes!)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: primaryColor,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Workshop Name'),
                  CustomTextField(
                    text: 'Enter your Workshop Name',
                    controller: workshopNameController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Workshop Address'),
                  CustomTextField(
                    text: 'Workshop Address',
                    maxLines: 5,
                    controller: workshopAddressController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Experience'),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(blurRadius: 1.5, color: Colors.grey)
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: selectedIndex == index
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  experience[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildLabel('ID Proof'),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextField(
                            readOnly: true,
                            text: 'Add ID Proof',
                            controller: idProofController,
                            validator: (value) {}),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickIDProof,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(blurRadius: 1.5, color: Colors.grey)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor,
                            ),
                            child: const Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLabel('Specializations'),
                      const Text(
                        '(Max 6 Specializations)',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  CustomTextField(
                    readOnly: true,
                    suffix: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setStateDialog) {
                                return CustomSpecificationsDialog(
                                  headerItems: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    child: Text(
                                      'Select Specializations',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  context: context,
                                  children: List.generate(
                                    specifications.length,
                                    (index) {
                                      String item = specifications[index];
                                      bool isSelected =
                                          selectedItems.contains(item);

                                      return Column(
                                        children: [
                                          Divider(),
                                          ListTile(
                                            title: Text(item),
                                            trailing: Icon(
                                              isSelected
                                                  ? Icons.radio_button_on
                                                  : Icons.radio_button_off,
                                            ),
                                            onTap: () {
                                              setStateDialog(() {
                                                if (isSelected) {
                                                  selectedItems.remove(item);
                                                } else {
                                                  selectedItems.add(item);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  actionButton: MaterialButton(
                                    height: 60,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    minWidth: double.infinity,
                                    color: Colors.blue[500],
                                    onPressed: () {
                                      setState(() {
                                        specializationController.text =
                                            selectedItems.join(', ');
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    text: selectedItems.isEmpty
                        ? 'Select Specializations'
                        : '${selectedItems.length} Specializations selected',
                    controller: specializationController,
                    validator: (value) =>
                        selectedItems.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 30),
                  CustomMaterialButtom(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedIndex != null) {
                        try {
                          final StringImages stringImages = StringImages();
                          final FirebaseImageService firebaseService =
                              FirebaseImageService();
                          String base64ProfileImage = await stringImages
                              .fileBytesToBase64(profileImageBytes!);
                          await firebaseServices.saveProfessionalDetails(
                            workshopName: workshopNameController.text.trim(),
                            workshopAddress:
                                workshopAddressController.text.trim(),
                            experience: experience[selectedIndex!],
                            specializations: selectedItems,
                            idProofName: idProofController.text.trim(),
                            profileImageUrl: base64ProfileImage,
                          );

                          // Navigate and show success dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MultiRoleRegisterPage(),
                            ),
                            (route) => false,
                          );

                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: CupertinoAlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.check_circle,
                                          size: 100, color: Colors.green),
                                      SizedBox(height: 10),
                                      Text(
                                        'Requested\nSuccessfully',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please fill all fields and upload image.")),
                        );
                      }
                    },
                    buttonText: 'Request for Account Creation',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
