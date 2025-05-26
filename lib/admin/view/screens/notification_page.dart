import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customLoading();
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading notifications.'));
        }

        final notifications = snapshot.data?.docs ?? [];

        if (notifications.isEmpty) {
          return const Center(child: Text('No notifications available.'));
        }

        return ListView.builder(
          itemCount: notifications.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final data = notifications[index].data() as Map<String, dynamic>;
            final title = data['heading'] ?? 'No Title';
            final subtitle = data['content'] ?? '';

            return CustomNotificationTile(
              title: title,
              subtitle: subtitle,
            );
          },
        );
      },
    );
  }
}
