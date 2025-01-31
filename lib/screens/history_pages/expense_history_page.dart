import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants/style.dart';
import 'package:personal_finance/services/expense_service.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/models/expense_model.dart';

class ExpenseHistory extends StatefulWidget {
  const ExpenseHistory({Key? key}) : super(key: key);

  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  bool viewAll = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: getAllExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(60),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<Expense> expenses = snapshot.data!;
        if (!viewAll) {
          expenses = expenses.where((expense) {
            DateTime currentDate = DateTime.now();
            DateTime expenseDate = expense.selectedDate!;
            return currentDate.year == expenseDate.year &&
                currentDate.month == expenseDate.month;
          }).toList();
        }

        if (expenses.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        expenses.sort((a, b) => b.selectedDate!.compareTo(a.selectedDate!));

        return SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    foregroundColor: primaryPurple,
                  ),
                  onPressed: () {
                    setState(() {
                      viewAll = !viewAll;
                    });
                  },
                  child: Text(
                    viewAll
                        ? 'View ${DateFormat.MMMM().format(DateTime.now())}'
                        : 'View All',
                  ),
                ),
              ),
              SizedBox(
                height: 595,
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    Expense expense = expenses[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        expense.description!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconTheme(
                                      data: IconThemeData(
                                        color: black,
                                      ),
                                      child: categories
                                          .where((element) =>
                                              element.name == expense.category)
                                          .first
                                          .getIcon(),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  "-\$${expense.amount}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(expense.selectedDate!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
