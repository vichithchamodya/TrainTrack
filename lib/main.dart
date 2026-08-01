import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:traintrack/firebase_options.dart';
import 'package:traintrack/pages/authentication/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TrainTrack());
}

class TrainTrack extends StatelessWidget {
  const TrainTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Train Track",
      home: const Scaffold(body: Authenticate()),
    );
  }
}
