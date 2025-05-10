import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project_1/admin/view/screens/home/user_home_screen.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/all_auth_services/model/user_create_request_model.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/messages.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectIndex = 0;
  List<String> tabs = ['Requested', 'Completed & Rejected'];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab navigation bar
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            tabs.length,
            (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = index;
                      });
                    },
                    child: Container(
                      height: mq.height * 0.045,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.width * 0.015),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 6,
                          ),
                        ],
                        color:
                            selectIndex == index ? primaryColor : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // StreamBuilder for requests
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('mechanic_requests')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: customLoading());

            final requests = snapshot.data!.docs
                .map((doc) => UserCreateRequestModel.fromMap(
                    doc.data() as Map<String, dynamic>))
                .where((req) => selectIndex == 0
                    ? req.status == 'Requested'
                    : req.status != 'Requested')
                .toList();

            return requests.isEmpty
                ? Center(
                    child: Text(
                      'No ${tabs[selectIndex]} transactions found',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];

                      return CustomUserCards(
                        color: pickColor(req.status),
                        date: req.time,
                        address: req.location,
                        issuescount: req.services.length,
                        mechanicStatus: req.status == 'Requested'
                            ? 'No Mechanic Picked'
                            : req.status ?? 'N/A',
                        onClickViewDetails: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: AlertDialog(
                                  scrollable: true,
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  contentPadding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Breakdown Location'),
                                      Text(req.location,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      const Text('Issue'),
                                      Text(
                                        '${req.services.length} Issues selected',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text('Issue Description'),
                                      buildLabel(req.description ?? 'N/A'),
                                      const SizedBox(height: 10),
                                      const Text('Assigned Mechanic'),
                                      buildLabel(req.status == 'Requested'
                                          ? 'No one has accepted the work'
                                          : 'Work Picked by ${req.assignedMechanicName ?? 'N/A'}'),
                                      const SizedBox(height: 10),
                                      const Text('Requested On'),
                                      buildLabel(req.date),
                                      const SizedBox(height: 10),
                                      const Text('Status'),
                                      Text(
                                        req.status == 'Requested'
                                            ? 'No Mechanic Picked'
                                            : req.status,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: pickColor(req.status),
                                        ),
                                      ),
                                      if (req.status == 'Requested') ...[
                                        const Text(
                                          '(Waiting for a mechanic to accept your request.)',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                      const SizedBox(height: 20),
                                      MaterialButton(
                                        onPressed: () => Navigator.pop(context),
                                        height: 50,
                                        minWidth: double.infinity,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.red,
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
