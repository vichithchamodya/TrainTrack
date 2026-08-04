import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/pages/authentication/authenticate.dart';
import 'package:traintrack/pages/main_screen.dart';
import 'package:traintrack/widgets/side_menu.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //user data that the provider provides
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return Stack(children: [SideMenu(), const MainScreen()]);
    }
  }
}
