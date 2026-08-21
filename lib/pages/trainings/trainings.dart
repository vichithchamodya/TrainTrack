import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_tab_bar.dart';
import 'package:traintrack/pages/trainings/all_trainings.dart';
import 'package:traintrack/pages/trainings/free_trainings.dart';
import 'package:traintrack/pages/trainings/premium_trainings.dart';

class Trainings extends StatelessWidget {
  final String categoryName;

  const Trainings({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: const TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: CustomTabBar(
          tabs: const ["All Courses", "Free Courses", "Premium Courses"],
          tabViews: [
            AllTrainings(categoryName: categoryName),
            FreeTrainings(categoryName: categoryName),
            PremiumTrainings(categoryName: categoryName),
          ],
          indicatorColor: kSubMainColor,
        ),
      ),
    );
  }
}
