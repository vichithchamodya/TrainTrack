import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/data/category_data.dart';
import 'package:traintrack/services/user_service.dart';
import 'package:traintrack/models/category_model.dart';
import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/section_title.dart';
import 'package:traintrack/widgets/category_card.dart';
import 'package:traintrack/pages/trainings/trainings.dart';
import 'package:traintrack/widgets/daily_time_goal_card.dart';
import 'package:traintrack/pages/dashboard/all_categories.dart';
import 'package:traintrack/widgets/horizontal_training_card.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  // list of categories
  final categories = CategoryData().categoryList;

  // shared training stream so Recently Added / Most Popular / Top Rated
  // don't each open their own Firestore listener
  final _trainingsStream = TrainingService().getTraining();

  // state to toggle between horizontal and vertical view of categories
  bool isExpanded = false;

  Future<void> _adjustStudyGoal(UserModel user) async {
    final controller = TextEditingController(
      text: user.studyGoalMinutes.toString(),
    );
    final goal = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Study goal"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Minutes"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (goal != null && user.uid.isNotEmpty) {
      await UserService().updateStudyGoal(user.uid, goal);
    }
  }

  List<TrainingModel> _recentlyAdded(List<TrainingModel> trainings) {
    final sorted = [...trainings]
      ..sort((a, b) => b.trainingAddedDate.compareTo(a.trainingAddedDate));
    return sorted.take(10).toList();
  }

  List<TrainingModel> _mostPopular(List<TrainingModel> trainings) {
    final sorted = [...trainings]
      ..sort(
        (a, b) =>
            b.trainingEnrolledStudents.compareTo(a.trainingEnrolledStudents),
      );
    return sorted.take(10).toList();
  }

  List<TrainingModel> _topRated(List<TrainingModel> trainings) {
    final sorted = [...trainings]
      ..sort((a, b) => b.trainingRating.compareTo(a.trainingRating));
    return sorted.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          // daily time goal card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Builder(
              builder: (context) {
                final user = context.watch<UserModel?>();
                final trainedMinutes =
                    user?.trainingProgress.values.fold<int>(
                      0,
                      (total, item) => total + item.minutesSpent,
                    ) ??
                    0;
                final goal = user?.studyGoalMinutes ?? 15;
                return DailyTimeGoalCard(
                  progressValue: trainedMinutes / goal,
                  timeGoal: goal,
                  onAdjustGoal: user == null
                      ? null
                      : () => _adjustStudyGoal(user),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SectionTitle(
              title: "Categories",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCategories(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),

          // conditional rendering of category list
          if (!isExpanded)
            // horizontal list view for categories
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.055,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  CategoryModel category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CategoryCard(
                      categoryIcon: category.categoryIcon,
                      categoryName: category.categoryName,
                      categoryOnTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Trainings(categoryName: category.categoryName),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          else
            // grid view for categories when expanded
            GridView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                childAspectRatio: 4 / 1,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                CategoryModel category = categories[index];
                return CategoryCard(
                  categoryIcon: category.categoryIcon,
                  categoryName: category.categoryName,
                  categoryOnTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Trainings(categoryName: category.categoryName),
                      ),
                    );
                  },
                );
              },
            ),

          // button to show more / show less
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded; // toggle the state
                });
              },
              child: Text(
                isExpanded ? "Show Less" : "Show More",
                style: const TextStyle(
                  color: kSubMainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // shared stream powering Recently Added / Most Popular / Top Rated
          StreamBuilder<List<TrainingModel>>(
            stream: _trainingsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: kSubMainColor),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  child: Center(
                    child: Text(
                      "Unable to load trainings.",
                      style: TextStyle(color: kGreyColor),
                    ),
                  ),
                );
              }

              final trainings = snapshot.data ?? const <TrainingModel>[];
              final recentlyAdded = _recentlyAdded(trainings);
              final mostPopular = _mostPopular(trainings);
              final topRated = _topRated(trainings);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // most popular trainings
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SectionTitle(
                      title: "Most Popular Trainings",
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildHorizontalTrainingList(mostPopular),

                  // recently added trainings
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SectionTitle(title: "Recently Added", onTap: () {}),
                  ),
                  const SizedBox(height: 5),
                  _buildHorizontalTrainingList(recentlyAdded),

                  // top rated trainings
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SectionTitle(title: "Top Rated", onTap: () {}),
                  ),
                  const SizedBox(height: 5),
                  _buildHorizontalTrainingList(topRated),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalTrainingList(List<TrainingModel> trainings) {
    if (trainings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "Nothing here yet.",
          style: TextStyle(color: kGreyColor, fontSize: 13),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: trainings.length,
        itemBuilder: (context, index) {
          final training = trainings[index];
          return HorizontalTrainingCard(
            trainingId: training.trainingId,
            trainingName: training.trainingName,
            trainingAbout: training.trainingAbout,
            trainingImage: training.trainingImage,
            isPremium: training.isPremium,
            trainingRating: training.trainingRating,
          );
        },
      ),
    );
  }
}
