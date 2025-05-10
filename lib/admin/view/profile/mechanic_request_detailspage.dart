import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicRequestDetailspage extends StatefulWidget {
  MechanicRequestDetailspage({super.key});

  @override
  State<MechanicRequestDetailspage> createState() =>
      _MechanicRequestDetailspageState();
}

class _MechanicRequestDetailspageState extends State<MechanicRequestDetailspage>
    with TickerProviderStateMixin {
  List<String> servicspecialization = [
    'Engine Repair',
    'Brake System',
    'Electrical Repairs'
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _animationController.forward();

                          customAlertWidget(
                            context: context,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                  scale: _animation,
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: mq.width * .2,
                                  ),
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
                                child: Text(
                                  'Back to Requests',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  height: mq.height * .070,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () {
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _animationController.forward();

                          customAlertWidget(
                            context: context,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                  scale: _animation,
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: mq.width * .2,
                                  ),
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Back to Requests',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  height: mq.height * .070,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: mq.height,
            child: Padding(
              padding: EdgeInsets.all(mq.width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: mq.width * 0.050,
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mq.width * 0.044,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 50,
                      ),
                      SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John',
                            style: TextStyle(
                                fontSize: mq.width * .07,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'hohn21@gmail.com',
                            style: TextStyle(fontSize: mq.width * .042),
                          ),
                          Text('+91 1234567890'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildLabel('Workshop Name'),
                  CustomNullTextField(data: 'John\'s auto repair'),
                  SizedBox(height: 15),
                  buildLabel('Workshop Address'),
                  CustomNullTextField(
                      data: '4517 Washington Ave. Manchester, Kentucky 39495'),
                  SizedBox(height: 15),
                  buildLabel('Experience'),
                  CustomNullTextField(data: '5+ Years'),
                  SizedBox(height: 15),
                  buildLabel('Specialization'),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: servicspecialization.map((service) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.048,
                          vertical: mq.width * 0.025,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(mq.width * 0.105),
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
                          child: CustomNullTextField(data: 'Driving License')),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNullTextField extends StatelessWidget {
  final String data;
  CustomNullTextField({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: data,
      style: TextStyle(color: Colors.black),
      enabled: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
