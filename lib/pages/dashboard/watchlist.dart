import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_tab_bar.dart';
import 'package:traintrack/widgets/saved_trainings.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CustomTabBar(
        tabs: const ["All Trainings", "Free Trainings", "Premium Trainings"],
        tabViews: const [
          SavedTrainings(filter: WatchlistFilter.all),
          SavedTrainings(filter: WatchlistFilter.free),
          SavedTrainings(filter: WatchlistFilter.premium),
        ],
        indicatorColor: kSubMainColor,
      ),
    );
  }
}
