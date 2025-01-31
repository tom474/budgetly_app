import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/goal_model.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<GoalModel>> getAllGoals() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('goals')
      .snapshots()
      .asyncMap((snapshot) async {
    List<GoalModel> goals = [];

    for (var doc in snapshot.docs) {
      DocumentSnapshot document = await doc.reference.get();
      String goalId = doc.id;
      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        GoalModel goal = GoalModel(
          goalId: goalId,
          imagePath: data['imagePath'] ?? "",
          notes: data['notes'] ?? "",
          price: data['price'] ?? 0,
          saved: data['saved'] ?? 0.0,
          productName: data['productName'] ?? "",
          timeToBuy: GoalModel.convertTimestampToDateTime(data['timeToBuy']),
          url: data['url'] ?? "",
        );
        goals.add(goal);
      }
    }
    return goals;
  });
}

void updateGoalProcess(
  String goalId,
  int saved,
) async {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('users') // Replace with your collection name
      .doc(user!.uid)
      .collection("goals")
      .doc(goalId);
  // Update data
  try {
    await documentReference.update({
      'saved': saved, // Update specific fields and their new values
    });
    print('Document updated successfully!');
  } catch (e) {
    print('Error updating document: $e');
  }
}
