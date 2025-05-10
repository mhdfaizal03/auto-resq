import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/mechanic/models/services/mechanic_firebase_services.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:shimmer/shimmer.dart';

class MechanicHomePage extends StatefulWidget {
  const MechanicHomePage({super.key});

  @override
  State<MechanicHomePage> createState() => _MechanicHomePageState();
}

class _MechanicHomePageState extends State<MechanicHomePage> {
  final _service = FirebaseMechanicService();
  final amountController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static int selectedIndex = 0;
  static bool isExpanded = false;

  List<String> selectedItems = [
    'Mechanic Picked',
    'Work In Progress',
    'On the Way',
    'Work Completed',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          CustomToggleSwitch(
            onToggle: (int? index) {
              setState(() {
                selectedIndex = index!;
              });
            },
            selectedIndex: selectedIndex,
            labels: ['Requests', 'Accepted'],
            switches: 2,
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('mechanic_requests')
                .orderBy('createdAt')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No data found');
              }

              final filtered = snapshot.data!.docs.where((req) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                final data = req.data() as Map<String, dynamic>;
                final status = data['status'];
                final assignedId = data.containsKey('assignedMechanicId')
                    ? data['assignedMechanicId']
                    : '';

                if (selectedIndex == 0) {
                  return status == 'Requested' || status == 'Pending';
                } else {
                  return status != 'Requested' ||
                      status != 'Pending' && assignedId == uid;
                }
              }).toList();

              if (filtered.isEmpty || snapshot.data!.docs.isEmpty) {
                return Center(child: const Text('No data found'));
              }

              return ListView.builder(
                reverse: true,
                itemCount: filtered.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final request = filtered[index];
                  return InkWell(
                    onTap: () {
                      amountController.text = request['amount'] ?? 0;
                      String tempPickedItem = request['status'];
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomRequestAcceptAlertDialog(
                            isPaid: request['isPaid'] ?? false,
                            amountController: amountController,
                            assignedMechanicName:
                                request['assignedMechanicName'] ?? '',
                            buttonEnterText: request['status'] == 'Pending' ||
                                    request['status'] == 'Requested'
                                ? 'Accept'
                                : 'Save',
                            date: request['date'],
                            isExpanded: isExpanded,
                            issueText: request['issueText'],
                            location: request['location'],
                            pickStatus: request['status'] == 'Pending' ||
                                    request['status'] == 'Requested'
                                ? 'No Mechanic Picked'
                                : tempPickedItem,
                            serviceLength:
                                List<String>.from(request['services']).length,
                            serviceText: List<String>.from(request['services']),
                            specificationsSelectText:
                                '${(request['services'] as List).length} Service selected',
                            onChooseStatusAction: () {
                              if (request['status'] != 'Pending') {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return CustomSpecificationsDialog(
                                          headerItems: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 18),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Select Status',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          context: context,
                                          children: List.generate(
                                            selectedItems.length,
                                            (i) {
                                              final item = selectedItems[i];
                                              return Column(
                                                children: [
                                                  Divider(),
                                                  InkWell(
                                                    onTap: () {
                                                      setDialogState(() {
                                                        tempPickedItem =
                                                            selectedItems[i];
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              item,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700),
                                                            ),
                                                          ),
                                                          Icon(
                                                            tempPickedItem ==
                                                                    item
                                                                ? Icons
                                                                    .radio_button_checked
                                                                : Icons
                                                                    .radio_button_off,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            minWidth: double.infinity,
                                            color: Colors.blue[500],
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Done',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            onSaveAction: () async {
                              if (formKey.currentState?.validate() ?? true) {
                                final user = FirebaseAuth.instance.currentUser;

                                final data = await FirebaseFirestore.instance
                                    .collection('mechanics')
                                    .doc(user!.uid)
                                    .get();
                                if (data == null) return;

                                final mechname = data.data();

                                if (request['status'] == 'Pending' ||
                                    request['status'] == 'Requested') {
                                  await _service.acceptRequest(
                                    workShopName: data['workshopName'],
                                    // status: tempPickedItem,
                                    requestId: request.id,
                                    mechanicName: mechname?['name'],
                                  );
                                } else {
                                  await _service.updateStatusAndAmount(
                                    isPaid:
                                        request['amount'] == "" ? false : true,
                                    id: request.id,
                                    status: tempPickedItem,
                                    amount: tempPickedItem ==
                                                'Work Completed' &&
                                            amountController.text.isNotEmpty
                                        ? double.tryParse(amountController.text)
                                        : null,
                                  );
                                }

                                amountController.clear();
                                Navigator.pop(context);
                                setState(() {});
                                CustomSnackBar.show(
                                  context: context,
                                  message: 'Status updated successfully',
                                  color: Colors.green,
                                  icon: Icons.check_circle,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                    child: CustomMechaniRequestCards(
                      userName: request['userName'] ?? '',
                      status: request['status'] == 'Requested' ||
                              request['status'] == 'Requested'
                          ? 'No Mechanic Picked'
                          : request['status'] ?? '',
                      date: request['date'] ?? 'N/A',
                      time: request['time'] ?? 'N/A',
                      phoneNo: request['phoneNo'],
                      place: request['location'],
                      services: request['services'],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
