import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class EvacMapApp extends StatelessWidget {
  const EvacMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evac Map',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}
