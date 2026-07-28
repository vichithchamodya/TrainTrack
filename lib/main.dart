import 'package:flutter/material.dart';
import 'package:traintrack/pages/authentication/signup_screen.dart';

void main() {
  runApp(const TrainTrack());
}

class TrainTrack extends StatelessWidget {
  const TrainTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Train Track",
      home: const Scaffold(body: SignupScreen()),
    );
  }
}
