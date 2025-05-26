import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicUsersHome extends StatelessWidget {
  const MechanicUsersHome({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'User')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!.docs;

        return Column(
          children: users.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CustomUsersCards(
              image: data['profileImage'] ?? '',
              name: data['name'] ?? 'No Name',
              email: data['email'] ?? 'No Email',
              phone: data['mobile'] ?? 'No Phone',
              place: data['place'] ?? 'Unknown',
            );
          }).toList(),
        );
      },
    );
  }
}
