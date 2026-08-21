import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_tab_bar.dart';
import 'package:traintrack/pages/trainings/all_trainings.dart';
import 'package:traintrack/pages/trainings/free_trainings.dart';
import 'package:traintrack/pages/trainings/premium_trainings.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: CustomTabBar(
        tabs: ["All Courses", "Free Courses", "Premium Courses"],
        tabViews: [
          AllTrainings(categoryName: "ABC"),
          FreeTrainings(categoryName: "ABC"),
          PremiumTrainings(categoryName: "ABC"),
        ],
        indicatorColor: kSubMainColor,
      ),
    );
  }
}
