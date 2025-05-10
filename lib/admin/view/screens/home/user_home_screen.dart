import 'package:flutter/material.dart';
import 'package:mini_project_1/utils/widgets.dart';

class MechanicUsersHome extends StatefulWidget {
  const MechanicUsersHome({super.key});

  @override
  State<MechanicUsersHome> createState() => _MechanicUsersHomeState();
}

class _MechanicUsersHomeState extends State<MechanicUsersHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(10, (index) {
          return CustomUsersCards(
              image:
                  'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
              name: 'John Luther',
              email: 'thismail@gmail.com',
              phone: '+91 123456789',
              place: 'Calicut');
        }),
      ),
    );
  }
}
