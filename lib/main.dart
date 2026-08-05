import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:traintrack/pages/wrapper.dart';
import 'package:traintrack/services/auth.dart';
import 'package:traintrack/firebase_options.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const TrainTrack(),
    ),
  );
}

class TrainTrack extends StatelessWidget {
  const TrainTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: "", username: ""),
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Train Track",
        theme: Provider.of<ThemeProvider>(context).getThemeData,
        home: const Scaffold(body: Wrapper()),
      ),
    );
  }
}
