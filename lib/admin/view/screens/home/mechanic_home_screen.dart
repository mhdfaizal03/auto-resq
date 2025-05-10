// Separate widget for Mechanic View
import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return CustomMechanicCards(
          isAccepted: index == 2 || index == 5 ? false : true,
          image: '',
          name: 'John Abraham',
          phone: '+91 1234567890',
          place: 'calicut',
          services_count: '10+ Services',
        );
      },
    );
  }
}
