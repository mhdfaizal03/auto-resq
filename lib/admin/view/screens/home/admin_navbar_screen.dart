import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/profile/profile_screen.dart';
import 'package:mini_project_1/admin/view/screens/home/mechanic_home_screen.dart';
import 'package:mini_project_1/admin/view/screens/notification_page.dart';
import 'package:mini_project_1/admin/view/screens/wallet/wallet_tab.dart';
import 'package:mini_project_1/common_screens/toggle_button_screen.dart';
import 'package:mini_project_1/main.dart';
import 'package:mini_project_1/utils/colors.dart';

class AdminNavbarScreen extends StatefulWidget {
  int? selectedIndex = 0;
  AdminNavbarScreen({this.selectedIndex, super.key});

  @override
  State<AdminNavbarScreen> createState() => _AdminNavbarScreenState();
}

class _AdminNavbarScreenState extends State<AdminNavbarScreen> {
  List<Widget> pages = [
    ToggleButtonScreen(),
    WalletTab(),
    NotificationPage(),
  ];

  // int selectedIndex = 0;

  List<Map<String, dynamic>> bottomIcons = [
    {
      'selected': 'assets/nav_icons/home_selected.png',
      'unselected': 'assets/nav_icons/home_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/wallet_selected.png',
      'unselected': 'assets/nav_icons/wallet_unselected.png',
    },
    {
      'selected': 'assets/nav_icons/notification_selected.png',
      'unselected': 'assets/nav_icons/notification_unselected.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: mq.width * 0.11,
              ),
            )
          : null,
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
                        ? 'Wallet'
                        : 'Notification',
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/AutoResQ.png',
                        width: 120,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'profile',
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(
                                'https://cdn.prod.website-files.com/62d84e447b4f9e7263d31e94/6399a4d27711a5ad2c9bf5cd_ben-sweet-2LowviVHZ-E-unsplash-1.jpeg'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                pages[widget.selectedIndex ?? 0],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
