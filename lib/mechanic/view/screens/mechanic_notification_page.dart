import 'package:flutter/cupertino.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicNotificationPage extends StatefulWidget {
  const MechanicNotificationPage({super.key});

  @override
  State<MechanicNotificationPage> createState() =>
      _MechanicNotificationPageState();
}

class _MechanicNotificationPageState extends State<MechanicNotificationPage> {
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
