import 'package:flutter/material.dart';
import 'package:mini_project_1/user/view/screens/user_home_page.dart';
import 'package:mini_project_1/user/view/screens/user_notification.dart';
import 'package:mini_project_1/user/view/screens/user_profile.dart';
import 'package:mini_project_1/user/view/screens/user_create_requests_page.dart';
import 'package:mini_project_1/user/view/screens/user_shop.dart';
import 'package:mini_project_1/utils/colors.dart';

class UserNavPage extends StatefulWidget {
  UserNavPage({super.key});

  @override
  State<UserNavPage> createState() => _UserNavPageState();
}

class _UserNavPageState extends State<UserNavPage> {
  List<Widget> pages = [
    UserHomePage(),
    UserShop(),
    UserNotification(),
    UserProfile(),
  ];

  static int selectedIndex = 0;

  List<Map<String, dynamic>> bottomIcons = [
    {
      'selected': 'assets/nav_icons/warning_selected.png',
      'unselected': 'assets/nav_icons/warning_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/shop_selected.png',
      'unselected': 'assets/nav_icons/shop_unselected.png',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserCreateRequestsPage()));
                },
                color: primaryColor,
                height: 55,
                minWidth: double.infinity,
                child: Text(
                  'Create a request',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : SizedBox.shrink(),
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
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
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
                    ? 'Requests'
                    : index == 1
                        ? 'Shop'
                        : index == 2
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                pages[selectedIndex],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
