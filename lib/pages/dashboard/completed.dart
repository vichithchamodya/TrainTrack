import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/completed_training_card.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    final progressMap =
        context.watch<UserModel?>()?.trainingProgress ?? const {};
    final completedProgress =
        progressMap.values.where((p) => p.completed).toList()..sort((a, b) {
          final aTime = a.lastActivityAt ?? DateTime(0);
          final bTime = b.lastActivityAt ?? DateTime(0);
          return bTime.compareTo(aTime); // most recently completed first
        });

    if (completedProgress.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lotties/empty.json",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const Text(
              "No completed trainings yet.",
              style: TextStyle(color: kGreyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return StreamBuilder<List<TrainingModel>>(
      stream: TrainingService().getTraining(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kSubMainColor),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Unable to load trainings.",
              style: TextStyle(color: kGreyColor),
            ),
          );
        }

        final trainings = snapshot.data ?? const <TrainingModel>[];
        final trainingsById = {for (final t in trainings) t.trainingId: t};

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          itemCount: completedProgress.length,
          itemBuilder: (context, index) {
            final progress = completedProgress[index];
            final training = trainingsById[progress.trainingId];

            return CompletedTrainingCard(
              trainingId: progress.trainingId,
              trainingName: progress.trainingName.isNotEmpty
                  ? progress.trainingName
                  : (training?.trainingName ?? ""),
              trainingImage: training?.trainingImage ?? "",
              isPremium: training?.isPremium ?? false,
              trainingRating: training?.trainingRating ?? 0.0,
              minutesSpent: progress.minutesSpent,
              completedOn: progress.lastActivityAt,
            );
          },
        );
      },
    );
  }
}
