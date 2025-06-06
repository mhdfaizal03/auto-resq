// notification_page_by_role.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/time_and_date_formats.dart';
import 'package:mini_project_1/utils/widgets.dart';

class NotificationPageByRole extends StatelessWidget {
  final String role; // 'User', 'Mechanic', 'Shop', 'All'

  const NotificationPageByRole({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> notificationStream = (role == 'All')
        ? FirebaseFirestore.instance
            .collection('notifications')
            // .orderBy('timestamp', descending: true)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('notifications')
            .where('role', whereIn: ['All', role])
            // .orderBy('timestamp', descending: true)
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: notificationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customLoading();
        }
        if (snapshot.hasError) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .65,
              ),
              child: const Center(child: Text('No notifications available.')));
        }

        final notifications = snapshot.data?.docs ?? [];
        if (notifications.isEmpty) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .65,
              ),
              child: const Center(child: Text('No notifications available.')));
        }

        return ListView.builder(
          itemCount: notifications.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = notifications[index].data() as Map<String, dynamic>;
            final title = data['heading'] ?? 'No Title';
            final subtitle = data['content'] ?? '';
            final roleSent = dateFormatter(data['timestamp']);

            return CustomNotificationTile(
              title: title,
              subtitle: subtitle,
              trialing: roleSent,
            );
          },
        );
      },
    );
  }
}
