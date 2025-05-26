import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicView extends StatelessWidget {
  const MechanicView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mechanics')
          .where('role', isEqualTo: 'Mechanic')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customLoading();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No mechanics found.'));
        }

        final mechanics = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mechanics.length,
          itemBuilder: (context, index) {
            final data = mechanics[index].data() as Map<String, dynamic>;
            return CustomMechanicCards(
              isAccepted: data['isAdminAccept'],
              image: data['profileImage'] ?? '',
              name: data['name'] ?? 'No Name',
              phone: data['mobile'] ?? 'No Phone',
              place: data['place'] ?? 'Unknown',
              services_count: data['servicesCount'] ?? '0 Services',
            );
          },
        );
      },
    );
  }
}
