import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/models/review_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/custom_button.dart';

class RatingPage extends StatefulWidget {
  final String trainingId;
  final String trainingName;

  const RatingPage({
    super.key,
    required this.trainingId,
    required this.trainingName,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _selectedRating = 0;
  final int _maxFeedbackLength = 200;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0 || _isSubmitting) return;

    final user = context.read<UserModel?>();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final reviewerId = user?.uid.isNotEmpty == true
        ? user!.uid
        : firebaseUser?.uid ?? "";

    if (reviewerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in to leave a review.")),
      );
      return;
    }

    final reviewerName = user?.username.trim().isNotEmpty == true
        ? user!.username
        : (firebaseUser?.displayName?.trim().isNotEmpty == true
              ? firebaseUser!.displayName!
              : (firebaseUser?.email?.split('@').first ?? "User"));

    setState(() => _isSubmitting = true);

    try {
      await TrainingService().addReview(
        widget.trainingId,
        ReviewModel(
          reviewerName: reviewerName,
          reviewerId: reviewerId,
          reviewDate: DateTime.now(),
          reviewRating: _selectedRating,
          reviewText: _feedbackController.text.trim(),
          photoUrl: user?.photoUrl ?? "",
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kSubMainColor,
          showCloseIcon: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          content: Text(
            "Thank you for your feedback! 🥰",
            style: TextStyle(color: kWhiteColor),
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context);
        });
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't submit your review: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rate ${widget.trainingName}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lotties/rate_yellow.json",
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "How was your experience?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "We'd love to hear your feedback. Please rate your experience below",
                style: TextStyle(fontSize: 16, color: kGreyColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            setState(() {
                              _selectedRating = index + 1;
                            });
                          },
                    icon: Icon(
                      Icons.star,
                      color: index < _selectedRating
                          ? kRatingColor
                          : Colors.grey.shade300,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_selectedRating > 0) ...[
                Text(
                  "You selected $_selectedRating star(s)",
                  style: const TextStyle(fontSize: 16, color: kOrangeColor),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _feedbackController,
                  maxLines: 5,
                  maxLength: _maxFeedbackLength,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    hintText: "Write your feedback...",
                    hintStyle: const TextStyle(color: kGreyColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kSubMainColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    counterText:
                        "${_feedbackController.text.length}/$_maxFeedbackLength",
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 30),
                _isSubmitting
                    ? const CircularProgressIndicator(color: kSubMainColor)
                    : CustomButton(
                        buttonText: "Submit Feedback",
                        buttonColor1: kSubMainColor,
                        buttonColor2: kMainColor,
                        onPressed: _submitReview,
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
