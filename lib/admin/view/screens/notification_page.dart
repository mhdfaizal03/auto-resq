import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomNotificationTile(
          title: 'Payment Received',
          subtitle: 'Payment received \$345 from Ram to Mechanic John',
        );
      },
    );
  }
}
