import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/expense_model.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<Expense>> getAllExpenses() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('expenses')
      .snapshots()
      .asyncMap((snapshot) async {
    List<Expense> expenses = [];

    for (var doc in snapshot.docs) {
      DocumentSnapshot document = await doc.reference.get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Expense expense = Expense(
          expenseId: doc.id,
          amount: (data["amount"] ?? 0).toDouble(),
          category: data["category"] ?? "",
          description: data["description"] ?? "",
          reminderDate:
              Expense.convertTimestampToDateTime(data["reminderDate"]),
          selectedDate:
              Expense.convertTimestampToDateTime(data["selectedDate"]),
        );
        expenses.add(expense);
      }
    }

    return expenses;
  });
}
