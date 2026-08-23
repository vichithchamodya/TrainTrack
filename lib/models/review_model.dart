import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewerName;
  final String reviewerId;
  final DateTime reviewDate;
  final int reviewRating;
  final String reviewText;

  ReviewModel({
    required this.reviewerName,
    this.reviewerId = "",
    required this.reviewDate,
    required this.reviewRating,
    required this.reviewText,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> data) {
    return ReviewModel(
      reviewerName: data["reviewerName"] ?? "",
      reviewerId: data["reviewerId"] ?? "",
      reviewDate: data["reviewDate"] != null
          ? (data["reviewDate"] as Timestamp).toDate()
          : DateTime.now(),
      reviewRating: data["reviewRating"]?.toInt() ?? 0,
      reviewText: data["reviewText"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
    "reviewerName": reviewerName,
    "reviewerId": reviewerId,
    "reviewDate": Timestamp.fromDate(reviewDate),
    "reviewRating": reviewRating,
    "reviewText": reviewText,
  };

  // method for dynamic date formatting
  String get dynamicDate {
    final now = DateTime.now();
    final difference = now.difference(reviewDate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? "s" : ""} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? "s" : ""} ago";
    } else {
      return DateFormat("yyyy-MM-dd").format(reviewDate);
    }
  }
}
