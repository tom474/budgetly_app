// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

enum Priority {
  High,
  Medium,
  Low,
}

class Plan {
  Plan({
    required this.id,
    required this.taskName,
    required this.budget,
    required this.date,
    required this.category,
    required this.priority,
  });

  final String id;
  final String taskName;
  final double budget;
  final DateTime date;
  final Category category;
  final Priority priority;

  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Priority convertStringToPriority(String priorityString) {
    switch (priorityString) {
      case 'High':
        return Priority.High;
      case 'Medium':
        return Priority.Medium;
      case 'Low':
        return Priority.Low;
      default:
        throw Exception('Invalid priority string: $priorityString');
    }
  }
}
