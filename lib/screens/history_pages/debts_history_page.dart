import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/services/debt_service.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/models/expense_model.dart';
import 'package:personal_finance/screens/home_page/home_page.dart';

class DebtHistory extends StatefulWidget {
  const DebtHistory({Key? key}) : super(key: key);

  @override
  State<DebtHistory> createState() => _DebtHistoryState();
}

class _DebtHistoryState extends State<DebtHistory> {
  @override
  Widget build(BuildContext context) {
    void handleOnFinishDebt(Expense debt) {
      bool isValidMoney = true;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Finish Debt'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Are you finish this debt ?"),
                ),
                if (!isValidMoney) // Use a conditional for error message
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You don't have enough money to finish this debt",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  if (debt.amount! > HomePage.totalMoney) {
                    isValidMoney = false;
                    // Show the dialog again to update the UI
                    Navigator.of(context).pop();
                    handleOnFinishDebt(debt);
                  } else {
                    deleteDebt(debt.expenseId);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Finish',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<List<Expense>>(
      stream: getAllDebts(),
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

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }
        List<Expense> debts = snapshot.data!;

        debts.sort((a, b) => b.selectedDate!.compareTo(a.selectedDate!));
        
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: debts.length,
              itemBuilder: (context, index) {
                Expense debt = debts[index];
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
                                    debt.description!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconTheme(
                                  data: IconThemeData(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: categories
                                      .where((element) =>
                                          element.name == debt.category)
                                      .first
                                      .getIcon(),
                                )
                              ],
                            ),
                            const Spacer(),
                            Text(
                              "+\$${debt.amount}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(debt.selectedDate!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(
                                  eccentricity: 0.3,
                                ),
                                backgroundColor: Colors.green.shade300,
                                foregroundColor: Colors.green.shade900,
                              ),
                              onPressed: () {
                                handleOnFinishDebt(debt);
                              },
                              child: const Icon(Icons.attach_money),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
