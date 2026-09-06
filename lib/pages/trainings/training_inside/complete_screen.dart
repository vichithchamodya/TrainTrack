import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/pages/main_screen.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/pages/trainings/training_inside/rating_screen.dart';
import 'package:traintrack/models/certificate_template.dart';
import 'package:traintrack/pages/trainings/training_inside/certificate_screen.dart';

class CompleteScreen extends StatelessWidget {
  final String trainingId;
  final String trainingName;
  final CertificateTemplate? certificateTemplate;
  final DateTime completedAt;

  const CompleteScreen({
    super.key,
    required this.trainingId,
    required this.trainingName,
    required this.certificateTemplate,
    required this.completedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            _buildHero(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  _buildMilestoneCard(context),
                  _buildCertificateAction(context),
                  const SizedBox(height: 20),
                  _buildSecondaryActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final animationSize = width < 380 ? 220.0 : 270.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 62),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kWhiteColor, kMainColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              color: kWhiteColor,
              icon: const Icon(Icons.close),
              tooltip: "Close",
            ),
          ),
          SizedBox(
            height: animationSize,
            width: animationSize,
            child: Lottie.asset(
              "assets/lotties/completed.json",
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            "Congratulations!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You crossed the finish line.",
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.82),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -38),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kGreenColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kGreenColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Milestone unlocked",
                    style: TextStyle(
                      fontSize: 12,
                      color: kGreenColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    trainingName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        buttonText: "Download Certificate",
        buttonColor1: kMainColor,
        buttonColor2: kSubMainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CertificateScreen(
                trainingName: trainingName,
                template: certificateTemplate,
                completedAt: completedAt,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecondaryActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showFeedbackDialog(context),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text("Review"),
            style: OutlinedButton.styleFrom(
              foregroundColor: kOrangeColor,
              side: const BorderSide(color: kOrangeColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            },
            icon: const Icon(Icons.lightbulb_outline),
            label: const Text("Keep learning"),
            style: OutlinedButton.styleFrom(
              foregroundColor: kGreenColor,
              side: const BorderSide(color: kGreenColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("How did it feel?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/lotties/rate_blue.json", height: 130),
            const Text(
              "Your feedback helps make the next training better.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: kGreyColor),
            child: const Text("Maybe later"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RatingPage(
                    trainingId: trainingId,
                    trainingName: trainingName,
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: kOrangeColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Rate now"),
          ),
        ],
      ),
    );
  }
}
