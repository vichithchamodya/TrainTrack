import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/user_service.dart';
import 'package:traintrack/widgets/custom_tab_bar.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/training_details_status_item.dart';
import 'package:traintrack/pages/trainings/training_details/about.dart';
import 'package:traintrack/pages/trainings/training_details/modules.dart';
import 'package:traintrack/pages/trainings/training_details/reviews.dart';
import 'package:traintrack/pages/trainings/training_inside/training_screen.dart';

class TrainingDetailPage extends StatelessWidget {
  final String trainingId;

  const TrainingDetailPage({super.key, required this.trainingId});

  Future<void> _toggleWatchlist(BuildContext context) async {
    final user = context.read<UserModel?>();
    final uid = user?.uid.isNotEmpty == true
        ? user!.uid
        : FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      _showWatchlistMessage(context, "Please sign in to save trainings.");
      return;
    }

    try {
      final saved = await UserService().toggleWatchlist(uid, trainingId);
      if (context.mounted) {
        _showWatchlistMessage(
          context,
          saved
              ? "Training saved to your watchlist."
              : "Training removed from your watchlist.",
        );
      }
    } on FirebaseException catch (error) {
      if (context.mounted) {
        _showWatchlistMessage(
          context,
          "Could not save training: ${error.code}.",
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showWatchlistMessage(context, "Could not save training. Try again.");
      }
    }
  }

  void _showWatchlistMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _trainingLink(TrainingModel training) {
    return "https://traintrack.app/trainings/${training.trainingId}";
  }

  Future<void> _shareTraining(
    BuildContext context,
    TrainingModel training,
  ) async {
    final link = _trainingLink(training);
    final text = "Check out \"${training.trainingName}\" on TrainTrack!\n$link";

    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> _copyLink(BuildContext context, TrainingModel training) async {
    await Clipboard.setData(ClipboardData(text: _trainingLink(training)));
    if (context.mounted) {
      _showWatchlistMessage(context, "Link copied to clipboard.");
    }
  }

  void _showMoreOptions(BuildContext context, TrainingModel training) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // hanger
                Container(
                  height: 5,
                  width: 48,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kSubMainColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.link, color: kSubMainColor),
                  ),
                  title: const Text(
                    "Copy Link",
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Text(
                    "Copy a shareable link to this training",
                    style: TextStyle(fontSize: 12, color: kGreyColor),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _copyLink(context, training);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kRedColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.flag_outlined, color: kRedColor),
                  ),
                  title: const Text(
                    "Report an Issue",
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Text(
                    "Let us know about a problem with this training",
                    style: TextStyle(fontSize: 12, color: kGreyColor),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showReportDialog(context, training);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context, TrainingModel training) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Report an issue"),
        content: TextField(
          controller: reasonController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Describe what's wrong with this training...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (context.mounted) {
                _showWatchlistMessage(
                  context,
                  "Thanks — your report has been submitted.",
                );
              }
              // TODO: persist the report
              // FirebaseFirestore.instance.collection("reports").add({
              //   "trainingId": training.trainingId,
              //   "reason": reasonController.text,
              //   "reportedAt": FieldValue.serverTimestamp(),
              // });
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
          }

          // get training details using trainingId
          final TrainingModel training = snapshot.data!.firstWhere(
            (training) => training.trainingId == trainingId,
          );

          return Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: Stack(
                  children: [
                    // background image
                    Positioned.fill(
                      child: Image.network(
                        training.trainingImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // transparent overlay
                    Positioned.fill(
                      child: Container(color: const Color(0x34000000)),
                    ),
                    // foreground content
                    NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          // sliver app bar
                          SliverAppBar(
                            expandedHeight: 250,
                            floating: false,
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                  ),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text(""),
                                ),
                              ),
                            ),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: kWhiteColor,
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  const Color(0x63FFFFFF),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        context
                                                    .watch<UserModel?>()
                                                    ?.watchlist
                                                    .contains(trainingId) ==
                                                true
                                            ? Icons.bookmark
                                            : Icons.bookmark_outline,
                                        color: kRatingColor,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              const Color(0x63FFFFFF),
                                            ),
                                      ),
                                      onPressed: () =>
                                          _toggleWatchlist(context),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        color: kWhiteColor,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              const Color(0x63FFFFFF),
                                            ),
                                      ),
                                      onPressed: () =>
                                          _shareTraining(context, training),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: kWhiteColor,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              const Color(0x63FFFFFF),
                                            ),
                                      ),
                                      onPressed: () =>
                                          _showMoreOptions(context, training),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ];
                      },
                      body: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            // training details section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // hanger
                                  Center(
                                    child: Container(
                                      height: 6,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: kRatingColor,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "${training.trainingRating.toString()} (365 reviews)",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    training.trainingName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TrainingDetailsStatusItem(
                                        statusIcon: Icons.category,
                                        statusText: training.trainingCategory,
                                      ),
                                      TrainingDetailsStatusItem(
                                        statusIcon: Icons.play_lesson,
                                        statusText:
                                            "${training.trainingModules.length} Lessons",
                                      ),
                                      const TrainingDetailsStatusItem(
                                        statusIcon: Icons.school,
                                        statusText: "Certificate",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Divider(),

                            // tab bar
                            Expanded(
                              child: CustomTabBar(
                                tabs: const [
                                  "About",
                                  "Hands-on lessons",
                                  "What students say",
                                ],
                                tabViews: [
                                  About(
                                    trainingAbout: training.trainingAbout,
                                    trainingDescription1:
                                        training.trainingDescription1,
                                    trainingKeyFeatures:
                                        training.trainingKeyFeatures,
                                    trainingImage: training.trainingImage,
                                    trainingDescription2:
                                        training.trainingDescription2,
                                    trainingDescription3:
                                        training.trainingDescription3,
                                  ),
                                  Modules(
                                    trainingModules: training.trainingModules,
                                  ),
                                  Reviews(
                                    trainingReviews: training.trainingReviews,
                                  ),
                                ],
                                indicatorColor: kSubMainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNavigationBar(context, training),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    TrainingModel training,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Total Price\n",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kGreyColor,
                    ),
                  ),
                  TextSpan(
                    text: training.isPremium
                        ? "\$${training.trainingFee.toStringAsFixed(2).toString()}"
                        : "Free",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kSubMainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            buttonText: training.isPremium ? "Enroll Now" : "Start Now",
            buttonColor1: kMainColor,
            buttonColor2: kSubMainColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingScreen(
                    trainingId: training.trainingId,
                    trainingName: training.trainingName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
