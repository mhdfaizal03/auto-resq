import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project_1/mechanic/models/services/mechanic_firebase_services.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class ProfessionalDetailsEditPage extends StatefulWidget {
  const ProfessionalDetailsEditPage({super.key});

  @override
  State<ProfessionalDetailsEditPage> createState() =>
      _ProfessionalDetailsEditPageState();
}

class _ProfessionalDetailsEditPageState
    extends State<ProfessionalDetailsEditPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseMechanicService firebaseServices = FirebaseMechanicService();

  final workshopNameController = TextEditingController();
  final workshopAddressController = TextEditingController();
  final idProofController = TextEditingController();
  final specializationController = TextEditingController();

  int? selectedIndex;
  Uint8List? profileImageBytes;
  bool isDataInitialized = false;

  final List<String> experience = ["0-2 Year", "2-5 Year", "5+ Year"];
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

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      setState(() {
        profileImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _pickIDProof() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      setState(() {
        idProofController.text = result.files.single.name;
      });
    }
  }

  @override
  void dispose() {
    workshopNameController.dispose();
    workshopAddressController.dispose();
    idProofController.dispose();
    specializationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Center(child: Text('User not logged in'));

    return Scaffold(
      appBar: AppBar(title: Text("Edit Professional Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mechanics')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || !snapshot.data!.exists)
            return Center(child: Text('No mechanic data found'));

          final data = snapshot.data!.data() as Map<String, dynamic>;

          if (!isDataInitialized) {
            workshopNameController.text = data['workshopName'] ?? '';
            workshopAddressController.text = data['workshopAddress'] ?? '';
            idProofController.text = data['idProofName'] ?? '';
            selectedItems = List<String>.from(data['specializations'] ?? []);
            specializationController.text =
                '${selectedItems.length.toString()} Specifications Selected';
            selectedIndex = experience.indexOf(data['experience'] ?? '');
            isDataInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Profile Image"),
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
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Workshop Name'),
                  CustomTextField(
                    text: 'Enter Workshop Name',
                    controller: workshopNameController,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  buildLabel('Workshop Address'),
                  CustomTextField(
                    text: 'Enter Workshop Address',
                    controller: workshopAddressController,
                    maxLines: 4,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
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
                            onTap: () => setState(() => selectedIndex = index),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(blurRadius: 1.5, color: Colors.grey)
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  experience[index],
                                  style: TextStyle(
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
                          text: 'ID Proof',
                          controller: idProofController,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
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
                                'Change',
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
                  buildLabel('Specializations'),
                  CustomTextField(
                    readOnly: true,
                    text: 'Specializations',
                    controller: specializationController,
                    suffix: IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      onPressed: () => _showSpecializationDialog(context),
                    ),
                    validator: (val) =>
                        selectedItems.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 30),
                  CustomMaterialButtom(
                    buttonText: 'Update Details',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await firebaseServices.updateProfessionalDetails(
                            workshopName: workshopNameController.text.trim(),
                            workshopAddress:
                                workshopAddressController.text.trim(),
                            experience: experience[selectedIndex!],
                            specializations: selectedItems,
                            idProofName: idProofController.text,
                            profileImageBytes: profileImageBytes,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Profile updated successfully')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSpecializationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomSpecificationsDialog(
              headerItems: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Text(
                  'Select Specializations',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              context: context,
              children: List.generate(
                specifications.length,
                (index) {
                  String item = specifications[index];
                  bool isSelected = selectedItems.contains(item);

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
                    specializationController.text = selectedItems.join(', ');
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
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return StatefulBuilder(builder: (context, setStateDialog) {
    //       return CustomSpecificationsDialog(
    //         headerItems: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    //           child: Text('Select Specializations',
    //               style: TextStyle(fontWeight: FontWeight.bold)),
    //         ),
    //         context: context,
    //         children: specifications.map((spec) {
    //           final isSelected = selectedItems.contains(spec);
    //           return Column(
    //             children: [
    //               Divider(),
    //               ListTile(
    //                 title: Text(spec),
    //                 trailing: Icon(
    //                   isSelected ? Icons.check_circle : Icons.circle_outlined,
    //                   color: isSelected ? Colors.green : null,
    //                 ),
    //                 onTap: () {
    //                   setStateDialog(() {
    //                     if (isSelected) {
    //                       selectedItems.remove(spec);
    //                     } else if (selectedItems.length < 6) {
    //                       selectedItems.add(spec);
    //                     }
    //                   });
    //                 },
    //               ),
    //             ],
    //           );
    //         }).toList(),
    //         actionButton: MaterialButton(
    //           height: 55,
    //           color: primaryColor,
    //           shape: const RoundedRectangleBorder(
    //             borderRadius:
    //                 BorderRadius.vertical(bottom: Radius.circular(10)),
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               specializationController.text = selectedItems.join(', ');
    //             });
    //             Navigator.pop(context);
    //           },
    //           child: const Text('Save', style: TextStyle(color: Colors.white)),
    //         ),
    //       );
    //     });
    //   },
    // );
  }
}
