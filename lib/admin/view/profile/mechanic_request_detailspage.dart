import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicRequestDetailspage extends StatefulWidget {
  final String mechanicId;
  MechanicRequestDetailspage({super.key, required this.mechanicId});

  @override
  State<MechanicRequestDetailspage> createState() =>
      _MechanicRequestDetailspageState();
}

class _MechanicRequestDetailspageState extends State<MechanicRequestDetailspage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchMechanicDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(widget.mechanicId)
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildActionButtons(),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchMechanicDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No mechanic data found.'));
            }

            final data = snapshot.data!;
            final List<dynamic> specializations = data['specializations'] ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(mq.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 50,
                          backgroundImage: data['profileImageUrl'] != null
                              ? MemoryImage(
                                  base64Decode(data['profileImageUrl']))
                              : null,
                          child: data['profileImage'] == null
                              ? Icon(Icons.person, size: 40)
                              : null,
                        ),
                        SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? '',
                              style: TextStyle(
                                  fontSize: mq.width * .07,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(data['email'] ?? '',
                                style: TextStyle(fontSize: mq.width * .042)),
                            Text(data['phone'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildLabel('Workshop Name'),
                    CustomTextField(
                      readOnly: true,
                      text: data['workshopName'] ?? '',
                    ),
                    SizedBox(height: 15),
                    buildLabel('Workshop Address'),
                    CustomTextField(
                      readOnly: true,
                      text: data['workshopAddress'] ?? '',
                    ),
                    SizedBox(height: 15),
                    buildLabel('Experience'),
                    CustomTextField(
                      readOnly: true,
                      text: data['experience'] ?? '',
                    ),
                    SizedBox(height: 15),
                    buildLabel('Specialization'),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: specializations.map<Widget>((service) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.width * 0.048,
                            vertical: mq.width * 0.025,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(mq.width * 0.105),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: mq.width * 0.037,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 15),
                    buildLabel('ID Proof'),
                    Row(
                      children: [
                        Expanded(
                            child: CustomTextField(
                          readOnly: true,
                          text: data['idProofName'] ?? 'N/A',
                        )),
                        SizedBox(width: 5),
                        Container(
                          height: mq.height * .070,
                          width: mq.width * .2,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'View',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => showRejectDialog(),
              child: Container(
                height: mq.height * .070,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () => showApproveDialog(),
              child: Container(
                height: mq.height * .070,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Accept', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showRejectDialog() {
    customAlertWidget(
      context: context,
      content: Text(
        'Confirm Reject\nApproval?',
        style: TextStyle(
          fontSize: mq.width * .055,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        MaterialButton(
          onPressed: () async {
            Navigator.pop(context);
            _animationController.forward();

            // Update Firestore document
            await FirebaseFirestore.instance
                .collection('mechanics')
                .doc(widget.mechanicId)
                .update({'isAdminAccept': 2});

            customAlertWidget(
              context: context,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _animation,
                    child: Icon(Icons.cancel,
                        color: Colors.red, size: mq.width * .2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Account Rejected!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: mq.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Back to Requests',
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
          child: Text('Confirm', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  void showApproveDialog() {
    customAlertWidget(
      context: context,
      content: Text(
        'Confirm Account\nApproval?',
        style: TextStyle(
          fontSize: mq.width * .055,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        MaterialButton(
          onPressed: () async {
            Navigator.pop(context);

            // ✅ Firestore update
            await FirebaseFirestore.instance
                .collection('mechanics')
                .doc(widget.mechanicId)
                .update({'isAdminAccept': 1});

            _animationController.forward();

            customAlertWidget(
              context: context,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _animation,
                    child: Icon(Icons.check_circle_rounded,
                        color: Colors.green, size: mq.width * .2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Account Approved!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: mq.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context); // closes alert
                    Navigator.pop(context); // returns to requests
                  },
                  child: Text('Back to Requests',
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
          child: Text('Confirm', style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }
}
