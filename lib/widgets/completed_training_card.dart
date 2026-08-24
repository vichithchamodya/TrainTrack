import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/pages/trainings/training_details/training_details.dart';

class CompletedTrainingCard extends StatelessWidget {
  final String trainingId;
  final String trainingName;
  final String trainingImage;
  final bool isPremium;
  final double trainingRating;
  final int minutesSpent;
  final DateTime? completedOn;

  const CompletedTrainingCard({
    super.key,
    required this.trainingId,
    required this.trainingName,
    required this.trainingImage,
    this.isPremium = false,
    this.trainingRating = 0.0,
    this.minutesSpent = 0,
    this.completedOn,
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
                gradient: isPremium
                    ? const LinearGradient(
                        colors: [kGreenColor, kSubMainColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
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
                                    color: isPremium
                                        ? kWhiteColor
                                        : kBlackColor,
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
                                  color: isPremium ? kWhiteColor : kGreyColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: isPremium ? kWhiteColor : kGreenColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isPremium ? kWhiteColor : kGreenColor,
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
