import 'package:flutter/material.dart';
import 'package:final_login/screen/login.dart';
import 'package:final_login/screen/register_page1.dart';
import 'package:final_login/screen/profile.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Workshop",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register_page1': (context) => RegisterPage1(),
        '/profile': (context) => ProfilePage(userId: ModalRoute.of(context)!.settings.arguments as int),
      },
    );
  }
}
