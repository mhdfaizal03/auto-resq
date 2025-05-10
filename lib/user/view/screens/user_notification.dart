import 'package:flutter/cupertino.dart';
import 'package:mini_project_1/utils/widgets.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomNotificationTile(
            title: 'Payment Received',
            subtitle: 'Payment received \$345 from Ram to Mechanic John',
          ),
        );
      },
    );
  }
}
