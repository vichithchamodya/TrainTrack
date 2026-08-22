import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/vertical_training_card.dart';

enum TrainingsFilter { all, free, premium }

class TrainingsList extends StatelessWidget {
  final String categoryName;
  final TrainingsFilter filter;

  const TrainingsList({
    super.key,
    required this.categoryName,
    this.filter = TrainingsFilter.all,
  });

  bool _matchesFilter(TrainingModel training) {
    if (training.trainingCategory != categoryName) return false;
    switch (filter) {
      case TrainingsFilter.free:
        return training.isPremium == false;
      case TrainingsFilter.premium:
        return training.isPremium == true;
      case TrainingsFilter.all:
        return true;
    }
  }

  String get _emptyMessage {
    final category = categoryName.toLowerCase();
    switch (filter) {
      case TrainingsFilter.free:
        return "No $category free courses yet..\nstay tuned !";
      case TrainingsFilter.premium:
        return "No $category premium courses yet..\nstay tuned !";
      case TrainingsFilter.all:
        return "No $category trainings yet..\nstay tuned !";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: StreamBuilder<List<TrainingModel>>(
        stream: TrainingService().getTraining(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                "assets/lotties/loader.json",
                height: 80,
                fit: BoxFit.cover,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Lottie.asset(
                    "assets/lotties/error.json",
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Oops! Something went wrong",
                    style: TextStyle(color: kGreyColor),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  const Text(
                    "No trainings avalable",
                    style: TextStyle(color: kGreyColor),
                  ),
                ],
              ),
            );
          }

          final trainings = snapshot.data!.where(_matchesFilter).toList();

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
      ),
    );
  }
}
