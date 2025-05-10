import 'package:flutter/material.dart';
import 'package:mini_project_1/admin/view/profile/mechanic_requests.dart';
import 'package:mini_project_1/admin/view/profile/terms_and_co.dart';
import 'package:mini_project_1/admin/view/auth/login_screen.dart';
import 'package:mini_project_1/admin/view/screens/notification_page.dart';
import 'package:mini_project_1/admin/view/screens/home/admin_navbar_screen.dart';
import 'package:mini_project_1/common_screens/toggle_button_screen.dart';
import 'package:mini_project_1/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> profileData = [
    {
      'title': 'Mechanic Requests',
      'leading': 'assets/profile_icons/people_profile.png',
      'trialing': Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
      ),
      'page': (context) => MechanicRequests(),
      'route': true,
    },
    {
      'title': 'Notifications',
      'leading': 'assets/profile_icons/notification_profile.png',
      'trialing': Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
      ),
      'page': (context) => AdminNavbarScreen(
            selectedIndex: 2,
          ),
      'route': false,
    },
    {
      'title': 'Terms and policy',
      'leading': 'assets/profile_icons/security_profile.png',
      'trialing': Icon(
        Icons.error,
        size: 0,
      ),
      'page': (context) => TermsAndCo(),
      'route': true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: mq.width * 0.050,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mq.width * 0.050,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    radius: mq.width * 0.15,
                    backgroundImage: NetworkImage(
                        'https://cdn.prod.website-files.com/62d84e447b4f9e7263d31e94/6399a4d27711a5ad2c9bf5cd_ben-sweet-2LowviVHZ-E-unsplash-1.jpeg'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Victoria David',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Super Admin',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: List.generate(
                  3,
                  (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: profileData[index]['page']),
                          (route) => profileData[index]['route'],
                        );
                      },
                      child: ProfileCards(
                        profileData[index]['trialing'],
                        image: profileData[index]['leading'],
                        title: profileData[index]['title'],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                    (route) => false,
                  );
                },
                child: Container(
                  height: mq.height * 0.070,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.width * 0.025),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 6,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Image.asset(
                        'assets/icons/logout.png',
                        width: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text('Version 2.343.3')
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCards extends StatelessWidget {
  String title;
  String image;
  Widget trialingIcon;

  ProfileCards(
    this.trialingIcon, {
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.068,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: ListTile(
            title: Text(title),
            leading: Image.asset(
              image,
              width: 30,
            ),
            trailing: trialingIcon),
      ),
    );
  }
}
