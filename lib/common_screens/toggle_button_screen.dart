import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/widgets.dart';
import 'package:mini_project_1/admin/view/screens/home/mechanic_home_screen.dart';
import 'package:mini_project_1/admin/view/screens/home/user_home_screen.dart';

class ToggleButtonScreen extends StatefulWidget {
  const ToggleButtonScreen({super.key});

  @override
  State<ToggleButtonScreen> createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CustomToggleSwitch(
              onToggle: (int? index) {
                setState(() {
                  _selectedIndex = index!;
                });
                print(_selectedIndex);
              },
              selectedIndex: _selectedIndex,
              labels: ['Users', 'Mechanic'],
              switches: 2),
          SizedBox(
            height: 20,
          ),
          _selectedIndex == 0 ? MechanicUsersHome() : MechanicView(),
        ],
      ),
    );
  }
}
