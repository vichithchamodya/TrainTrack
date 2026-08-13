import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';

class About extends StatelessWidget {
  final String trainingAbout;
  final String trainingDescription1;
  final List trainingKeyFeatures;
  final String trainingImage;
  final String trainingDescription2;
  final String trainingDescription3;

  const About({
    super.key,
    required this.trainingAbout,
    required this.trainingDescription1,
    required this.trainingKeyFeatures,
    required this.trainingImage,
    required this.trainingDescription2,
    required this.trainingDescription3,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About This Training",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Text(
              trainingAbout,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Key Highlights:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kGreyColor,
              ),
            ),
            const SizedBox(height: 5),

            // bullet points
            for (var i = 0; i < trainingKeyFeatures.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: kSubMainColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        trainingKeyFeatures[i],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // image section
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(trainingImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              trainingDescription1,
              style: const TextStyle(fontSize: 12, height: 1.5),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            Text(
              trainingDescription2,
              style: const TextStyle(fontSize: 12, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // additional description
            Text(
              trainingDescription3,
              style: const TextStyle(fontSize: 12, height: 1.5),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
