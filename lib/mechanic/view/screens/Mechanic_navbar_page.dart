import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_home_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_notification_page.dart';
import 'package:mini_project_1/mechanic/view/screens/mechanic_profile_page.dart';
import 'package:mini_project_1/utils/colors.dart';

class MechanicNavbarPage extends StatefulWidget {
  int? selectedIndex;
  MechanicNavbarPage({this.selectedIndex = 0, super.key});

  @override
  State<MechanicNavbarPage> createState() => _MechanicNavbarPageState();
}

class _MechanicNavbarPageState extends State<MechanicNavbarPage> {
  List<Widget> pages = [
    MechanicHomePage(),
    MechanicNotificationPage(),
    MechanicProfilePage(),
  ];

  List<Map<String, dynamic>> bottomIcons = [
    {
      'selected': 'assets/nav_icons/home_selected.png',
      'unselected': 'assets/nav_icons/home_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/notification_selected.png',
      'unselected': 'assets/nav_icons/notification_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/person_selected.png',
      'unselected': 'assets/nav_icons/person_unselected.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(color: primaryColor),
          currentIndex: widget.selectedIndex ?? 0,
          onTap: (value) {
            setState(() {
              widget.selectedIndex = value;
            });
          },
          items: List.generate(
            bottomIcons.length,
            (index) {
              return BottomNavigationBarItem(
                activeIcon: Image.asset(
                  bottomIcons[index]['selected'],
                  width: 30,
                ),
                label: index == 0
                    ? 'Home'
                    : index == 1
                        ? 'Notification'
                        : 'Profile',
                icon: Image.asset(
                  bottomIcons[index]['unselected'],
                  width: 30,
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/AutoResQ.png',
                        width: 120,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                pages[widget.selectedIndex!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
