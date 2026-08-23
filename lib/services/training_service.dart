import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:traintrack/models/training_model.dart';
import 'package:traintrack/models/module_model.dart';
import 'package:traintrack/models/review_model.dart';

class TrainingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              .orderBy("reviewDate", descending: true)
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

  Future<void> addReview(String trainingId, ReviewModel review) async {
    final trainingDoc = _trainingCollection.doc(trainingId);
    final reviewsCollection = trainingDoc.collection("trainingReviews");

    await reviewsCollection.add(review.toMap());

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(trainingDoc);
      final data = snapshot.data() as Map<String, dynamic>? ?? {};

      final currentCount = (data["trainingRatingCount"] as num?)?.toInt() ?? 0;
      final currentAverage =
          (data["trainingRating"] as num?)?.toDouble() ?? 0.0;

      final newCount = currentCount + 1;
      final newAverage =
          ((currentAverage * currentCount) + review.reviewRating) / newCount;

      transaction.set(trainingDoc, {
        "trainingRating": newAverage,
        "trainingRatingCount": newCount,
      }, SetOptions(merge: true));
    });
  }
}
