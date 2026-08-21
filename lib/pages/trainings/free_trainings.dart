import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/vertical_training_card.dart';

class FreeTrainings extends StatelessWidget {
  final String categoryName;

  const FreeTrainings({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: StreamBuilder(
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
                  // lottie animation
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
                  // lottie animation
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
          } else {
            // filter trainings by category name and ispremium
            final List<TrainingModel> trainings = snapshot.data!
                .where(
                  (training) =>
                      training.trainingCategory == categoryName &&
                      training.isPremium == false,
                )
                .toList();

            // check if filtered trainings are empty
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
                      "No ${categoryName.toLowerCase()} free courses yet..\nstay tuned !",
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
                final TrainingModel training = trainings[index];
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
          }
        },
      ),
    );
  }
}
