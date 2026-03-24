import 'package:ecosyncai/core/network/network.dart';
import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/features/home/presentations/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Network.init();
  await SharedPreferences.getInstance().then((value) => value.getString('token') ?? '');
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}