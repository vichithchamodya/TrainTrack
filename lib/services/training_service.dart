import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/models/module_model.dart';
import 'package:traintrack/models/review_model.dart';

class TrainingService {
  // reference to the firestore collection
  final CollectionReference _trainingCollection = FirebaseFirestore.instance
      .collection("trainings");

  // method to get all the trainings from the firestore collection
  Stream<List<TrainingModel>> getTraining() {
    return _trainingCollection.snapshots().asyncMap((snapshot) async {
      return Future.wait(
        snapshot.docs.map((doc) async {
          final trainingData = doc.data() as Map<String, dynamic>;

          // fetch lessons
          final lessonsSnapshot = await _trainingCollection
              .doc(doc.id)
              .collection("trainingModules")
              .get();
          final lessons = lessonsSnapshot.docs
              .map((lessonDoc) => ModuleModel.fromJson(lessonDoc.data()))
              .toList();

          // fetch reviews
          final reviewSnapshot = await _trainingCollection
              .doc(doc.id)
              .collection("trainingReviews")
              .get();
          final reviews = reviewSnapshot.docs
              .map((reviewDoc) => ReviewModel.fromJson(reviewDoc.data()))
              .toList();

          // create and return the TrainingModel
          return TrainingModel.fromJson(trainingData, doc.id, lessons, reviews);
        }).toList(),
      );
    });
  }
}


/*
class CourseService {
  // reference to the firestore collection
  final CollectionReference _courseCollection =
      FirebaseFirestore.instance.collection("courses");

  // method to get all the courses from the firestore collection
  Stream<List<CourseModel>> getCourse() {
    return _courseCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            CourseModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}
*/