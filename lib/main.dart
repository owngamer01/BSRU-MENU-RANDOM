import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_myapp/LoginPage.dart';
import 'package:test_myapp/RegisterPage.dart';
import 'package:test_myapp/SplashSreenPage.dart';
import 'package:test_myapp/view/Home.dart';
import 'package:test_myapp/view/MenuItem.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red
        ),
        initialRoute: '/',
        routes: {
          '/' : (_) => SplashScreenPage(),
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/home': (_) => HomePage()
        },
        onGenerateRoute: (RouteSettings setting) {
          final arg = setting.arguments as Map<String, dynamic>?;
          switch (setting.name) {
            case '/add_menu_item':
              return MaterialPageRoute(builder: (_) => AddMenuItem());
            case '/update_menu_item':
              return MaterialPageRoute(builder: (_) => AddMenuItem(
                isUpdate: true,
                menuItem: arg!['menuItem'],
                docId: arg['docId'],
              ));
            default:
          }
        },
      ),
    );
  }
}
