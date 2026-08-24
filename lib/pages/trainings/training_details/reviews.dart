import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/review_model.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/widgets/custom_review_card.dart';
import 'package:traintrack/pages/trainings/training_inside/rating_screen.dart';

class Reviews extends StatelessWidget {
  final String trainingId;
  final String trainingName;
  final List<ReviewModel> trainingReviews;

  const Reviews({
    super.key,
    required this.trainingId,
    required this.trainingName,
    required this.trainingReviews,
  });

  void _openRatingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RatingPage(trainingId: trainingId, trainingName: trainingName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratings = trainingReviews
        .map((review) => review.reviewRating)
        .toList();
    final totalReviews = ratings.length;
    final averageRating = totalReviews == 0
        ? 0.0
        : ratings.reduce((a, b) => a + b) / totalReviews;

    final Map<int, int> ratingBreakdown = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var rating in ratings) {
      if (ratingBreakdown.containsKey(rating)) {
        ratingBreakdown[rating] = ratingBreakdown[rating]! + 1;
      }
    }

    if (trainingReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lotties/empty.json",
              height: 180,
              width: 180,
              fit: BoxFit.cover,
            ),
            const Text(
              "No reviews yet. be the first!",
              style: TextStyle(color: kGreyColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: CustomButton(
                buttonText: "Write a Review",
                buttonColor1: kSubMainColor,
                buttonColor2: kMainColor,
                onPressed: () => _openRatingPage(context),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Employee Reviews",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton.icon(
                  onPressed: () => _openRatingPage(context),
                  icon: Icon(Icons.edit, color: kSubMainColor),
                  label: const Text(
                    "Write a Review",
                    style: TextStyle(color: kSubMainColor, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // rating summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(
              children: [
                // average rating
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$totalReviews review${totalReviews == 1 ? "" : "s"}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // star ratings breakdown
                Expanded(
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => _buildRatingBar(
                        5 - index,
                        ratingBreakdown[5 - index] ?? 0,
                        totalReviews,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // review cards
          Expanded(
            child: ListView.builder(
              itemCount: trainingReviews.length,
              itemBuilder: (context, index) {
                final review = trainingReviews[index];
                return CustomReviewCard(
                  name: review.reviewerName,
                  rating: review.reviewRating,
                  review: review.reviewText,
                  date: review.dynamicDate,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // helper to build the rating bar
  Widget _buildRatingBar(int star, int count, int totalReviews) {
    final percentage = totalReviews == 0
        ? 0
        : ((count / totalReviews) * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 25,
          child: Text(
            "$star★",
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, color: kGreyColor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade300,
            color: kSubMainColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 45,
          child: Text(
            "$percentage%",
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, color: kGreyColor),
          ),
        ),
      ],
    );
  }
}
