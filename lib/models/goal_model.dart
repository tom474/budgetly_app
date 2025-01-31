import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  String goalId;
  String? imagePath;
  String? notes;
  double price;
  int saved;
  String productName;
  DateTime timeToBuy;
  String? url;

  GoalModel({
    required this.goalId,
    this.imagePath,
    this.notes,
    required this.price,
    required this.saved,
    required this.productName,
    required this.timeToBuy,
    this.url,
  });

  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
