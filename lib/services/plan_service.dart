import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/models/plan_model.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<Plan>> getAllPlans() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('plans')
      .snapshots()
      .asyncMap((snapshot) async {
    List<Plan> plans = [];

    for (var doc in snapshot.docs) {
      DocumentSnapshot document = await doc.reference.get();
      String planId = doc.id;
      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Plan plan = Plan(
          id: planId,
          taskName: data['productName'],
          budget: data['price'],
          date: Plan.convertTimestampToDateTime(data['date']),
          category: categories
              .where((element) => element.name == data['category'])
              .first,
          priority: Plan.convertStringToPriority(data['priority']),
        );
        plans.add(plan);
      }
    }
    return plans;
  });
}

void deletePlan(String planId) async {
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("plans")
        .doc(planId)
        .delete();
    print('Document deleted successfully!');
  } catch (e) {
    print('Error deleting document: $e');
  }
}
