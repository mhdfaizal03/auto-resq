import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_project_1/common_screens/splash_screen.dart';
import 'package:mini_project_1/firebase_options.dart';
import 'package:mini_project_1/auth_pages/multi_register.dart';
import 'package:mini_project_1/user/view/screens/user_navbar_page.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
          fontFamily: 'Poppins',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              enableFeedback: true,
              elevation: 10,
              backgroundColor: Colors.white),
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent)),
      home: SplashIconScreen(),
      // home: ToggleButtonScreen(),
    );
  }
}
