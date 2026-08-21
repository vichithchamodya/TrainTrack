import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_tab_bar.dart';
import 'package:traintrack/pages/dashboard/ongoing.dart';
import 'package:traintrack/pages/dashboard/completed.dart';

class MyTrainings extends StatefulWidget {
  const MyTrainings({super.key});

  @override
  State<MyTrainings> createState() => _MyTrainingsState();
}

class _MyTrainingsState extends State<MyTrainings> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: CustomTabBar(
        tabs: ["Learning in Progress", "Goals Unlocked"],
        tabViews: [Ongoing(), Completed()],
        indicatorColor: kSubMainColor,
      ),
    );
  }
}
