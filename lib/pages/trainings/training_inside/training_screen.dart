import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/module_model.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/user_service.dart';
import 'package:traintrack/widgets/custom_button.dart';
import 'package:traintrack/services/training_service.dart';
import 'package:traintrack/widgets/custom_video_player.dart';
import 'package:traintrack/pages/trainings/training_inside/complete_screen.dart';

class TrainingScreen extends StatefulWidget {
  final String trainingId;
  final String trainingName;

  const TrainingScreen({
    super.key,
    required this.trainingId,
    required this.trainingName,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int _currentPage = 0;
  bool _progressLoaded = false;
  final Stopwatch _studyTimer = Stopwatch()..start();
  final UserService _userService = UserService();

  Future<void> _saveProgress({
    required int totalSteps,
    required bool completed,
  }) async {
    final user = context.read<UserModel?>();
    if (user == null || user.uid.isEmpty) return;
    final previous = user.trainingProgress[widget.trainingId];
    await _userService.saveProgress(
      user.uid,
      TrainingProgress(
        trainingId: widget.trainingId,
        trainingName: widget.trainingName,
        currentStep: completed ? totalSteps : _currentPage,
        totalSteps: totalSteps,
        minutesSpent:
            (previous?.minutesSpent ?? 0) +
            (_studyTimer.elapsed.inSeconds / 60).ceil(),
        completed: completed,
        lastActivityAt: DateTime.now(),
      ),
    );
    _studyTimer.reset();
    _studyTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainingName, style: const TextStyle(fontSize: 18)),
      ),
      body: StreamBuilder(
        stream: TrainingService().getTraining(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kSubMainColor,
                backgroundColor: kGreyColor,
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Lottie.asset(
                    "assets/lotties/empty.json",
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const Text("No results found"),
                ],
              ),
            );
          } else {
            // filter the training by id
            final training = snapshot.data!.firstWhere(
              (training) => training.trainingId == widget.trainingId,
            );

            final List<ModuleModel> lessons = training.trainingModules;
            final int totalLessons = lessons.length;
            if (lessons.isEmpty) {
              return const Center(
                child: Text('This training has no lessons yet.'),
              );
            }

            if (!_progressLoaded) {
              final progress = context
                  .read<UserModel?>()
                  ?.trainingProgress[widget.trainingId];
              _currentPage = (progress?.currentStep ?? 0).clamp(
                0,
                totalLessons - 1,
              );
              _progressLoaded = true;
            }

            // get the current lesson based on the page
            final currentLesson = lessons[_currentPage];

            return Column(
              children: [
                Expanded(
                  child: CustomVideoPlayer(videoUrl: currentLesson.moduleVideo),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentLesson.moduleName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // pagination controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? Expanded(
                              child: CustomButton(
                                buttonText: "Previous",
                                buttonColor1: kGreyColor,
                                buttonColor2: kGreyColor,
                                onPressed: _currentPage > 0
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                        _saveProgress(
                                          totalSteps: totalLessons,
                                          completed: false,
                                        );
                                      }
                                    : null,
                              ),
                            )
                          : const SizedBox(),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.arrow_back,
                      //     color: _currentPage > 0 ? kSubMainColor : kGreyColor,
                      //   ),
                      //   onPressed: _currentPage > 0
                      //       ? () {
                      //           setState(() {
                      //             _currentPage--;
                      //           });
                      //         }
                      //       : null,
                      // ),
                      Expanded(
                        child: Text(
                          'Lesson ${_currentPage + 1} of $totalLessons',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: kGreyColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonText: _currentPage < totalLessons - 1
                              ? "Next"
                              : "Finish",
                          buttonColor1: _currentPage < totalLessons - 1
                              ? kMainColor
                              : Colors.green,
                          buttonColor2: _currentPage < totalLessons - 1
                              ? kSubMainColor
                              : kGreenColor,
                          onPressed: _currentPage < totalLessons - 1
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                  _saveProgress(
                                    totalSteps: totalLessons,
                                    completed: false,
                                  );
                                }
                              : () {
                                  _saveProgress(
                                    totalSteps: totalLessons,
                                    completed: true,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CompleteScreen(),
                                    ),
                                  );
                                },
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.arrow_forward,
                      //     color: _currentPage < totalLessons - 1
                      //         ? kSubMainColor
                      //         : kGreyColor,
                      //   ),
                      //   onPressed: _currentPage < totalLessons - 1
                      //       ? () {
                      //           setState(() {
                      //             _currentPage++;
                      //           });
                      //         }
                      //       : null,
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
