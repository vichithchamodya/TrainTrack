import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:traintrack/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  UserService({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) =>
      _firestore.collection("users").doc(uid);

  Stream<UserModel> watchUser(
    String uid, {
    String? fallbackName,
    String? email,
  }) {
    return _userDocument(uid).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) {
        await _userDocument(uid).set({
          "username": fallbackName ?? "",
          "email": email ?? "",
          "photoUrl": "",
          "watchlist": <String>[],
          "trainingProgress": <String, dynamic>{},
          "studyGoalMinutes": 15,
        });
        return UserModel(
          uid: uid,
          username: fallbackName ?? "",
          email: email ?? "",
        );
      }

      final data = snapshot.data() ?? {};
      final storedUsername = (data["username"] as String? ?? "").trim();
      final storedEmail = (data["email"] as String? ?? "").trim();
      final needsBackfill =
          (storedUsername.isEmpty && (fallbackName ?? "").isNotEmpty) ||
          (storedEmail.isEmpty && (email ?? "").isNotEmpty);

      if (needsBackfill) {
        final updates = <String, dynamic>{
          if (storedUsername.isEmpty && (fallbackName ?? "").isNotEmpty)
            "username": fallbackName,
          if (storedEmail.isEmpty && (email ?? "").isNotEmpty) "email": email,
        };
        await _userDocument(uid).set(updates, SetOptions(merge: true));
        data.addAll(updates);
      }

      return UserModel.fromMap(uid, data);
    });
  }

  Future<bool> toggleWatchlist(String uid, String trainingId) async {
    final document = _userDocument(uid);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);
      final data = snapshot.data() ?? <String, dynamic>{};
      final watchlist = List<String>.from(
        data["watchlist"] as List? ?? const [],
      );
      final wasSaved = watchlist.contains(trainingId);

      if (wasSaved) {
        watchlist.remove(trainingId);
      } else {
        watchlist.add(trainingId);
      }

      transaction.set(document, {
        "watchlist": watchlist,
      }, SetOptions(merge: true));
      return !wasSaved;
    });
  }

  Future<void> saveProgress(String uid, TrainingProgress progress) {
    return _userDocument(uid).set({
      "trainingProgress": {progress.trainingId: progress.toMap()},
    }, SetOptions(merge: true));
  }

  Future<void> updateStudyGoal(String uid, int minutes) {
    return _userDocument(uid).set({
      "studyGoalMinutes": minutes.clamp(1, 1440),
    }, SetOptions(merge: true));
  }

  Future<void> updateProfileDetails(
    String uid, {
    String? username,
    String? email,
  }) {
    final updates = <String, dynamic>{"username": ?username, "email": ?email};
    if (updates.isEmpty) return Future.value();
    return _userDocument(uid).set(updates, SetOptions(merge: true));
  }

  Future<void> setAvatarPicture(String uid, String assetPath) {
    return _userDocument(
      uid,
    ).set({"photoUrl": assetPath}, SetOptions(merge: true));
  }

  // uploads [imageFile] to firebase storage and saves the download url
  // on the user's profile document. returns the new url.
  Future<String> updateProfilePicture(String uid, File imageFile) async {
    final ref = _storage.ref().child("profile_pictures").child("$uid.jpg");
    await ref.putFile(imageFile, SettableMetadata(contentType: "image/jpeg"));
    final downloadUrl = await ref.getDownloadURL();

    await _userDocument(
      uid,
    ).set({"photoUrl": downloadUrl}, SetOptions(merge: true));

    return downloadUrl;
  }

  Future<void> removeProfilePicture(String uid) async {
    final ref = _storage.ref().child("profile_pictures").child("$uid.jpg");
    try {
      await ref.delete();
    } catch (_) {
      // no existing picture - nothing to delete
    }
    await _userDocument(uid).set({"photoUrl": ""}, SetOptions(merge: true));
  }

  Future<void> markTrainingPurchased(String uid, String trainingId) {
    return _userDocument(uid).set({
      "purchasedTrainings": FieldValue.arrayUnion([trainingId]),
    }, SetOptions(merge: true));
  }
}
