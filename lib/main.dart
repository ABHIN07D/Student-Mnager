import 'package:flutter/material.dart';
import 'package:sqllite/databasehelper.dart';
import 'package:sqllite/splashCreen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sql',
      home:SplashScreen(),);
      }
}

