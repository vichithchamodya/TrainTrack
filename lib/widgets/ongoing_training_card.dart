import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/pages/trainings/training_details/training_details.dart';

class OngoingTrainingCard extends StatelessWidget {
  final String trainingId;
  final String trainingName;
  final String trainingImage;
  final bool isPremium;
  final double trainingRating;
  final int currentStep;
  final int totalSteps;
  final int minutesSpent;

  const OngoingTrainingCard({
    super.key,
    required this.trainingId,
    required this.trainingName,
    required this.trainingImage,
    this.isPremium = false,
    this.trainingRating = 0.0,
    this.currentStep = 0,
    this.totalSteps = 0,
    this.minutesSpent = 0,
  });

  Widget _buildImage() {
    final isNetworkImage = trainingImage.startsWith("http");
    if (trainingImage.isEmpty) return _imagePlaceholder();
    if (isNetworkImage) {
      return Image.network(
        trainingImage,
        height: 70,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    return Image.asset(
      trainingImage,
      height: 70,
      width: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return const SizedBox(
      height: 70,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: kGreyColor),
          Text(
            "Error loading image",
            style: TextStyle(fontSize: 10, color: kGreyColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = totalSteps > 0
        ? (currentStep / totalSteps).clamp(0.0, 1.0)
        : 0.0;
    final percentageLabel = "${(progressValue * 100).round()}%";
    final stepsRemaining = (totalSteps - currentStep).clamp(0, totalSteps);
    final stepsLabel = stepsRemaining == 0
        ? "Almost done"
        : "$stepsRemaining lesson${stepsRemaining == 1 ? "" : "s"} to go";

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainingDetailPage(trainingId: trainingId),
            ),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).appBarTheme.backgroundColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    child: _buildImage(),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trainingName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.star,
                                size: 15,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                trainingRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kGreyColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            stepsLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: kGreyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: Colors.grey.shade300,
                                  color: kSubMainColor,
                                  minHeight: 5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                percentageLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isPremium)
              Positioned(
                top: 5,
                left: -10,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [kBlackColor, kSubMainColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: kGreenColor,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: kWhiteColor,
                          size: 14,
                        ),
                        Text(
                          "Premium",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
