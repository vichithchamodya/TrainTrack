import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingProgress {
  final String trainingId;
  final String trainingName;
  final int currentStep;
  final int totalSteps;
  final int minutesSpent;
  final bool completed;
  final DateTime? lastActivityAt;

  const TrainingProgress({
    required this.trainingId,
    this.trainingName = "",
    required this.currentStep,
    required this.totalSteps,
    required this.minutesSpent,
    required this.completed,
    this.lastActivityAt,
  });

  factory TrainingProgress.fromMap(
    String trainingId,
    Map<String, dynamic> data,
  ) {
    final timestamp = data["lastActivityAt"];
    return TrainingProgress(
      trainingId: trainingId,
      trainingName: data["trainingName"] as String? ?? "",
      currentStep: (data["currentStep"] as num?)?.toInt() ?? 0,
      totalSteps: (data["totalSteps"] as num?)?.toInt() ?? 0,
      minutesSpent: (data["minutesSpent"] as num?)?.toInt() ?? 0,
      completed: data["completed"] as bool? ?? false,
      lastActivityAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
    "currentStep": currentStep,
    "trainingName": trainingName,
    "totalSteps": totalSteps,
    "minutesSpent": minutesSpent,
    "completed": completed,
    "lastActivityAt": lastActivityAt == null
        ? FieldValue.serverTimestamp()
        : Timestamp.fromDate(lastActivityAt!),
  };
}

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final List<String> watchlist;
  final List<String> purchasedTrainings;
  final Map<String, TrainingProgress> trainingProgress;
  final int studyGoalMinutes;
  final DateTime? createdAt;
  final bool isBanned;
  final String bannedReason;
  final DateTime? timeoutUntil;

  const UserModel({
    required this.uid,
    this.username = "",
    this.email = "",
    this.photoUrl = "",
    this.watchlist = const [],
    this.purchasedTrainings = const [],
    this.trainingProgress = const {},
    this.studyGoalMinutes = 15,
    this.createdAt,
    this.isBanned = false,
    this.bannedReason = "",
    this.timeoutUntil,
  });

  static DateTime? _dateTimeFromValue(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    final rawProgress = data["trainingProgress"] as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: uid,
      username: data["username"] as String? ?? "",
      email: data["email"] as String? ?? "",
      photoUrl: data["photoUrl"] as String? ?? "",
      watchlist: List<String>.from(data["watchlist"] as List? ?? const []),
      purchasedTrainings: List<String>.from(
        data["purchasedTrainings"] as List? ?? const [],
      ),
      trainingProgress: rawProgress.map(
        (id, value) => MapEntry(
          id,
          TrainingProgress.fromMap(id, Map<String, dynamic>.from(value as Map)),
        ),
      ),
      studyGoalMinutes: (data["studyGoalMinutes"] as num?)?.toInt() ?? 15,
      createdAt: _dateTimeFromValue(data["createdAt"]),
      isBanned: data["isBanned"] as bool? ?? false,
      bannedReason: data["bannedReason"] as String? ?? "",
      timeoutUntil: _dateTimeFromValue(data["timeoutUntil"]),
    );
  }
}
