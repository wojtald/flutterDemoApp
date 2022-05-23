import 'package:demo_app/models/app_list.dart';
import 'package:demo_app/screens/list_screen.dart';
import 'package:demo_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppList>(create: (context) => AppList(),),
        ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          ListScreen.routeName: (context) => ListScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}