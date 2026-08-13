import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:traintrack/models/module_model.dart';
import 'package:traintrack/models/review_model.dart';

class TrainingModel {
  final String trainingId;
  final String trainingCategory;
  final String trainingName;
  final String trainingAbout;
  final String trainingDescription1;
  final String trainingDescription2;
  final String trainingDescription3;
  final String trainingImage;
  final List<ModuleModel> trainingModules;
  final List trainingKeyFeatures;
  final int trainingEnrolledStudents;
  final DateTime trainingAddedDate;
  final bool isPremium;
  final double trainingFee;
  final double trainingRating;
  final List<ReviewModel> trainingReviews;

  TrainingModel({
    required this.trainingId,
    required this.trainingCategory,
    required this.trainingName,
    required this.trainingAbout,
    required this.trainingDescription1,
    required this.trainingDescription2,
    required this.trainingDescription3,
    required this.trainingImage,
    required this.trainingModules,
    required this.trainingKeyFeatures,
    required this.trainingEnrolledStudents,
    required this.trainingAddedDate,
    required this.isPremium,
    required this.trainingFee,
    required this.trainingRating,
    required this.trainingReviews,
  });

  // method to convert the firebase document in to a dart object
  factory TrainingModel.fromJson(
    Map<String, dynamic> data,
    String id,
    List<ModuleModel> modules,
    List<ReviewModel> reviews,
  ) {
    return TrainingModel(
      trainingId: id,
      trainingCategory: data["trainingCategory"] ?? "",
      trainingName: data["trainingName"] ?? "",
      trainingAbout: data["trainingAbout"] ?? "",
      trainingDescription1: data["trainingDescription1"] ?? "",
      trainingDescription2: data["trainingDescription2"] ?? "",
      trainingDescription3: data["trainingDescription3"] ?? "",
      trainingImage: data["trainingImage"] ?? "",
      trainingModules: modules,
      trainingKeyFeatures: List<String>.from(data["trainingKeyFeatures"] ?? []),
      trainingEnrolledStudents: data["trainingEnrolledStudents"] ?? 0,
      trainingAddedDate: data["trainingAddedDate"] != null
          ? (data["trainingAddedDate"] as Timestamp).toDate()
          : DateTime.now(),
      isPremium: data["trainingIsPremium"] ?? false,
      trainingFee: data["trainingFee"]?.toDouble() ?? 0.0,
      trainingRating: data["trainingRating"]?.toDouble() ?? 0.0,
      trainingReviews: reviews,
    );
  }
}
