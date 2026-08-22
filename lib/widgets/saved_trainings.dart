import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/vertical_training_card.dart';

enum WatchlistFilter { all, free, premium }

class SavedTrainings extends StatelessWidget {
  final WatchlistFilter filter;

  const SavedTrainings({super.key, this.filter = WatchlistFilter.all});

  bool _matchesFilter(TrainingModel training) {
    switch (filter) {
      case WatchlistFilter.free:
        return training.isPremium == false;
      case WatchlistFilter.premium:
        return training.isPremium == true;
      case WatchlistFilter.all:
        return true;
    }
  }

  String get _emptyMessage {
    switch (filter) {
      case WatchlistFilter.free:
        return "No free trainings in your watchlist yet.";
      case WatchlistFilter.premium:
        return "No premium trainings in your watchlist yet.";
      case WatchlistFilter.all:
        return "Your watchlist is empty.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedIds = context.watch<UserModel?>()?.watchlist ?? const <String>[];

    return StreamBuilder<List<TrainingModel>>(
      stream: TrainingService().getTraining(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kSubMainColor),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to load saved trainings.'));
        }

        final trainings = (snapshot.data ?? const <TrainingModel>[])
            .where((training) => savedIds.contains(training.trainingId))
            .where(_matchesFilter)
            .toList();

        if (trainings.isEmpty) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Lottie.asset(
                  "assets/lotties/empty.json",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  _emptyMessage,
                  style: const TextStyle(color: kGreyColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          itemCount: trainings.length,
          itemBuilder: (context, index) {
            final training = trainings[index];
            return VerticalTrainingCard(
              trainingId: training.trainingId,
              trainingName: training.trainingName,
              trainingAbout: training.trainingAbout,
              trainingImage: training.trainingImage,
              isPremium: training.isPremium,
              trainingRating: training.trainingRating,
            );
          },
        );
      },
    );
  }
}
