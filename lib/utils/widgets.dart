import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomTextField extends StatelessWidget {
  String? text;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  TextEditingController controller;
  int? minLines;
  int? maxLines;
  Widget? suffix;
  bool readOnly;
  TextInputType keyBoardType;
  CustomTextField({
    super.key,
    this.text,
    required this.validator,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffix = null,
    this.readOnly = false,
    this.onChanged,
    this.keyBoardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      onChanged: onChanged,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: suffix,
        hintText: text,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(mq.width * 0.025),
        ),
      ),
    );
  }
}

class CustomMaterialButtom extends StatelessWidget {
  Function()? onPressed;
  String buttonText;
  CustomMaterialButtom({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: primaryColor,
      onPressed: onPressed,
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomToggleSwitch extends StatelessWidget {
  Function(int?)? onToggle;
  int selectedIndex;
  List<String> labels;
  int switches;
  CustomToggleSwitch({
    super.key,
    required this.onToggle,
    required this.selectedIndex,
    required this.labels,
    required this.switches,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minHeight: mq.height * 0.06,
      minWidth: double.infinity,
      curve: Curves.ease,
      animate: true,
      activeBorders: [Border.all(color: primaryColor)],
      activeBgColor: [primaryColor],
      inactiveBgColor: Colors.white,
      inactiveFgColor: Colors.black,
      borderColor: [Colors.black],
      onToggle: onToggle,
      borderWidth: 1.4,
      initialLabelIndex: selectedIndex,
      totalSwitches: switches,
      labels: labels,
      fontSize: 17,
    );
  }
}

class CustomUsersCards extends StatelessWidget {
  String image;
  String name;
  String place;
  String phone;
  String email;
  CustomUsersCards({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(mq.width * 0.02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width * 0.025),
              child: SizedBox(
                height: mq.height * 0.12,
                width: mq.width * 0.25,
                child: Image.network(
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Image.asset('assets/icons/error.png')),
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(mq.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: mq.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  place,
                ),
                SizedBox(height: mq.height * 0.01),
                Text(
                  phone,
                ),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMechanicCards extends StatelessWidget {
  final String image;
  final String name;
  final String place;
  final String phone;
  final String services_count;
  final bool isAccepted;

  const CustomMechanicCards({
    super.key,
    required this.image,
    required this.name,
    required this.phone,
    required this.place,
    required this.services_count,
    required this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(mq.width * 0.02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width * 0.025),
              child: SizedBox(
                height: mq.height * 0.12,
                width: mq.width * 0.25,
                child: Image.network(
                  image,
                  errorBuilder: (context, error, stackTrace) => Center(
                      child: Image.asset(
                    'assets/icons/error.png',
                    width: mq.width * 0.20,
                  )),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: mq.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(place),
                  Text(phone),
                  SizedBox(height: mq.height * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        services_count,
                        style: TextStyle(
                          fontSize: mq.width * 0.033,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        height: mq.height * 0.035,
                        width: mq.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(mq.width * 0.125),
                            color: isAccepted ? Colors.green : Colors.red),
                        child: Center(
                          child: Text(
                            isAccepted ? 'Accepted' : 'Rejected',
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
        ],
      ),
    );
  }
}

class CustomWalletCards extends StatefulWidget {
  final String? fromUserName;
  final String? toMechanicName;
  final String? status;
  final String date;
  final String amount;
  final List<String> services;

  const CustomWalletCards({
    super.key,
    required this.fromUserName,
    required this.toMechanicName,
    required this.status,
    required this.date,
    required this.amount,
    required this.services,
  });

  @override
  _CustomWalletCardsState createState() => _CustomWalletCardsState();
}

class _CustomWalletCardsState extends State<CustomWalletCards> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.all(mq.width * .040),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From(User)'),
                    SizedBox(height: 5),
                    Text(
                      widget.fromUserName.toString(),
                      style: TextStyle(
                        fontSize: mq.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('To(Mechanic)'),
                    SizedBox(height: 5),
                    Text(
                      widget.toMechanicName.toString(),
                      style: TextStyle(
                        fontSize: mq.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.date,
                    style: TextStyle(
                      fontSize: mq.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.amount,
                    style: TextStyle(
                      fontSize: mq.width * 0.050,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: mq.height * 0.035,
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .055),
                    decoration: BoxDecoration(
                        color: widget.status == 'Pending'
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        widget.status == 'Pending'
                            ? 'Pending'
                            : 'Work Completed',
                        style: TextStyle(
                          fontSize: mq.width * 0.040,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  'Service Requested',
                  style: TextStyle(
                      fontSize: mq.width * .045,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
            child: isExpanded
                ? Column(
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: widget.services.map((service) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: mq.width * 0.040,
                              vertical: mq.width * 0.018,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[300],
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
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class CustomNotificationTile extends StatelessWidget {
  String title;
  String subtitle;
  CustomNotificationTile(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mq.width * 0.025),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 6,
            ),
          ],
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
                fontSize: mq.width * 0.045, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: mq.width * 0.038,
            ),
          ),
        ));
  }
}

class CustomMechanicRequestCards extends StatelessWidget {
  final String image;
  final String name;
  final String place;
  final String phone;
  final String services_count;
  final int index;
  final bool isAccepted;

  const CustomMechanicRequestCards({
    super.key,
    required this.image,
    required this.name,
    required this.phone,
    required this.place,
    required this.services_count,
    required this.isAccepted,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    if (index == 0) {
      statusText = 'Pending';
      statusColor = Colors.orange;
    } else if (isAccepted) {
      statusText = 'Accepted';
      statusColor = Colors.green;
    } else {
      statusText = 'Rejected';
      statusColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(mq.width * 0.02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.width * 0.025),
              child: SizedBox(
                height: mq.height * 0.12,
                width: mq.width * 0.25,
                child: Image.network(
                  image,
                  errorBuilder: (context, error, stackTrace) => Center(
                      child: Image.asset(
                    'assets/icons/error.png',
                    width: mq.width * 0.20,
                  )),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(mq.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: mq.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(place),
                  Text(phone),
                  SizedBox(height: mq.height * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        services_count,
                        style: TextStyle(
                          fontSize: mq.width * 0.033,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        height: mq.height * 0.035,
                        width: mq.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(mq.width * 0.125),
                          color: statusColor,
                        ),
                        child: Center(
                          child: Text(
                            statusText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void customAlertWidget(
    {BuildContext? context, Widget? content, List<Widget>? actions}) async {
  return showCupertinoDialog(
      context: context!,
      builder: (context) {
        return BackdropFilter(
          enabled: true,
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: CupertinoAlertDialog(content: content, actions: actions!),
        );
      });
}

Widget buildLabel(
  String text,
) {
  return Text(
    text,
    style: TextStyle(
      fontSize: mq.width * .045,
      fontWeight: FontWeight.bold,
    ),
  );
}

class CustomRickText extends StatelessWidget {
  String firstText;
  String secondText;
  Function()? onTap;
  CustomRickText(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
        ),
        children: <TextSpan>[
          TextSpan(
            text: secondText,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: primaryColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

class CustomSpecificationsDialog extends StatelessWidget {
  BuildContext context;
  List<Widget>? children;
  Widget? actionButton;
  Widget headerItems;
  CustomSpecificationsDialog({
    super.key,
    required this.children,
    required this.context,
    required this.actionButton,
    required this.headerItems,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                headerItems,
                Column(
                  children: children!,
                ),
                actionButton!,
              ],
            ),
          ),
        ),
      ],
    );
    ;
  }
}

class CustomMechaniRequestCards extends StatefulWidget {
  final String? userName;
  final String? place;
  final String? phoneNo;
  final String? status;
  final String date;
  final String time;
  final List<dynamic> services;

  const CustomMechaniRequestCards({
    super.key,
    required this.userName,
    required this.place,
    required this.phoneNo,
    required this.status,
    required this.services,
    required this.date,
    required this.time,
  });

  @override
  _CustomMechaniRequestCardsState createState() =>
      _CustomMechaniRequestCardsState();
}

class _CustomMechaniRequestCardsState extends State<CustomMechaniRequestCards> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.all(mq.width * 0.030),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header row with mechanic info and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Mechanic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName ?? 'N/A',
                      style: TextStyle(
                        fontSize: mq.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.place ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.phoneNo ?? 'No phone'),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// Date, Time, Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.date,
                    style: TextStyle(
                      fontSize: mq.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.time,
                    style: TextStyle(
                      fontSize: mq.width * 0.035,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: mq.height * 0.035,
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .040),
                    decoration: BoxDecoration(
                      color: pickColor(widget.status ?? ''),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        widget.status ?? 'Unknown',
                        style: TextStyle(
                          fontSize: mq.width * 0.040,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Service toggle
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  'Service Requested',
                  style: TextStyle(
                    fontSize: mq.width * .038,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                ),
              ],
            ),
          ),

          /// Expanded service list
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
            child: isExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: widget.services.map((service) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: mq.width * 0.040,
                              vertical: mq.width * 0.018,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[300],
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
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

Widget pickStatusColorText(String text, String currentStatus) {
  return Text(
    text,
    style: TextStyle(
      color: pickColor(currentStatus),
      fontSize: mq.width * 0.040,
      fontWeight: FontWeight.bold,
    ),
  );
}

class CustomRequestAcceptAlertDialog extends StatelessWidget {
  bool isExpanded;
  String specificationsSelectText;
  int serviceLength;
  List<String> serviceText;
  String location;
  String issueText;
  String assignedMechanicName;
  String date;
  String pickStatus;
  String buttonEnterText;
  TextEditingController amountController;
  bool isPaid;
  Function() onChooseStatusAction;
  Function() onSaveAction;

  CustomRequestAcceptAlertDialog({
    super.key,
    required this.assignedMechanicName,
    required this.buttonEnterText,
    required this.date,
    required this.isExpanded,
    required this.issueText,
    required this.location,
    required this.pickStatus,
    required this.serviceLength,
    required this.serviceText,
    required this.specificationsSelectText,
    required this.onChooseStatusAction,
    required this.onSaveAction,
    required this.amountController,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        scrollable: true,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        contentPadding: EdgeInsets.all(10),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Breakdown Location',
                ),
                Text(
                  location.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Service Requested',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    setDialogState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 1.5),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                specificationsSelectText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: isExpanded
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: List.generate(
                                        serviceLength,
                                        (i) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey[300],
                                          ),
                                          child: Text(
                                            serviceText[i].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Issue Description'),
                Text(
                  issueText.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Assigned Mechanic'),
                Text(
                  'Your Mechanic Name ${assignedMechanicName.toString()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Requested On'),
                Text(
                  date.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Status',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: onChooseStatusAction,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 1.5),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pickStatus.toString(),
                            style: TextStyle(
                                color: pickColor(pickStatus),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (pickStatus != 'No Mechanic Picked') ...[
                  Text('Final Repair Cost'),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    text: ' Enter the total repair amount',
                    validator: (val) {
                      if (val!.isEmpty || val == null) {
                        return 'please enter a value to complete';
                      }
                      return null;
                    },
                    controller: amountController,
                    readOnly: isPaid ? true : false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: !isPaid ? Colors.red : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Unpaid',
                              style: TextStyle(
                                  color: !isPaid ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.green : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Paid',
                              style: TextStyle(
                                  color: isPaid ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.2, color: Colors.red)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onSaveAction,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              buttonEnterText.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomUserCards extends StatelessWidget {
  String date;
  String address;
  int issuescount;
  String mechanicStatus;
  Color? color;
  Function() onClickViewDetails;
  CustomUserCards(
      {super.key,
      required this.date,
      required this.address,
      required this.issuescount,
      required this.mechanicStatus,
      required this.color,
      required this.onClickViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            SizedBox(
              height: 10,
            ),
            buildLabel(address),
            SizedBox(
              height: 10,
            ),
            Text(
              '$issuescount Issues',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      mechanicStatus,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onClickViewDetails,
                  child: Text(
                    'View Details',
                    style: TextStyle(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [Icon(Icons.chevron_left_rounded), Text('Back')],
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2.0,
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      );
    },
  );
}

class ProfileCards extends StatelessWidget {
  final String title;
  final String image;
  final Widget trialingIcon;

  const ProfileCards(
    this.trialingIcon, {
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.068,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: ListTile(
          title: Text(title),
          leading: Image.asset(image, width: 30),
          trailing: trialingIcon,
        ),
      ),
    );
  }
}

class ShopCards extends StatelessWidget {
  String? productName;
  String? productPrice;
  String? productQuantity;
  String? productImage;
  String? deliveryDate;
  String? deliveryStatus;
  Color? deliveryStatusColor;

  ShopCards({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productQuantity,
    required this.deliveryDate,
    required this.deliveryStatus,
    required this.deliveryStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 1.5, color: Colors.grey)]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 1.5, color: Colors.grey)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://5.imimg.com/data5/SELLER/Default/2023/10/349750049/RC/TP/ZK/87613070/1-500x500.jpg',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Poppins'),
                          children: [
                        TextSpan(
                            text: 'Status | ',
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: deliveryStatus.toString(),
                            style: TextStyle(color: deliveryStatusColor)),
                      ])),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${productName.toString()} (${productQuantity.toString()})',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        productName.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₹${productPrice.toString()}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'Delivery in ${deliveryDate.toString()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget customLoading() {
  return Center(
    child: CircularProgressIndicator(
      color: primaryColor,
      strokeWidth: 2.0,
    ),
  );
}
