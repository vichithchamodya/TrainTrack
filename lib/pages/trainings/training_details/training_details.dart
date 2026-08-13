import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/models/training_model.dart';
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
                                      icon: const Icon(
                                        Icons.bookmark_outlined,
                                        color: kRatingColor,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              const Color(0x63FFFFFF),
                                            ),
                                      ),
                                      onPressed: () {},
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
                                      onPressed: () {},
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
                                      onPressed: () {},
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
