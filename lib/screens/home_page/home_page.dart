// Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Package imports (external libraries)
import 'package:rxdart/rxdart.dart';

// Project-relative imports
import 'package:personal_finance/services/debt_service.dart';
import 'package:personal_finance/services/expense_service.dart';
import 'package:personal_finance/services/income_service.dart';
import 'package:personal_finance/components/side_bar.dart';
import 'package:personal_finance/components/tracking_selection.dart';
import 'package:personal_finance/models/expense_model.dart';
import 'package:personal_finance/screens/home_page/display_tracking.dart';
import 'package:personal_finance/constants/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static double totalMoney = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<double> _incomeMoneyNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _outcomeMoneyNotifier =
      ValueNotifier<double>(0.0);

  @override
  void dispose() {
    _incomeMoneyNotifier.dispose();
    _outcomeMoneyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    void onTotalAmountChanged(double amount) {
      setState(() {
        totalAmount = amount;
      });
    }

    var iconMoney = Container(
        width: 40,
        height: 40,
        decoration: const ShapeDecoration(
          color: Color(0x7F0000FF),
          shape: OvalBorder(),
        ),
        padding: const EdgeInsets.all(6.0),
        child: SvgPicture.asset(
          'assets/icons/icon_money.svg',
        ));

    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shadowColor: Theme.of(context).colorScheme.shadow,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          // color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              myWallet(
                  amount: totalAmount,
                  incomeMoneyNotifier: _incomeMoneyNotifier,
                  outcomeMoneyNotifier: _outcomeMoneyNotifier),
              // financeStatus(),
              FinancialStatusCard(
                incomeMoneyNotifier: _incomeMoneyNotifier,
                outcomeMoneyNotifier: _outcomeMoneyNotifier,
                onTotalAmountChanged: onTotalAmountChanged,
              ),
              introductionCard(iconMoney, context),
              callToAction(iconMoney, context),
              // display the goal of user
              const DisplayTracking(
                collectionName: "goals",
                title: "Saving Goal",
              ),
              const DisplayTracking(collectionName: "plans", title: "Plan"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navigationBar(context),
    );
  }

  InkWell callToAction(Container iconMoney, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/weekly_plan_form');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(right: 6.0),
                  child: iconMoney),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your weekly plan',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF030303),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    Text(
                      'We can support you in managing your budget daily',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_forward_ios_rounded)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell introductionCard(Container iconMoney, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/add_goal');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Saving goal',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF030303),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'We can support you in achieve your goal',
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(left: 6.0),
                  child: iconMoney),
            ],
          ),
        ),
      ),
    );
  }

  Card myWallet({
    required double amount,
    required ValueNotifier<double> incomeMoneyNotifier,
    required ValueNotifier<double> outcomeMoneyNotifier,
  }) {
    return Card(
      color: const Color(0x943066BE),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ValueListenableBuilder<double>(
          valueListenable: incomeMoneyNotifier,
          builder: (context, incomeValue, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text(
                      'My Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.white,
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.wallet,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder<double>(
                              valueListenable: outcomeMoneyNotifier,
                              builder: (context, outcomeValue, _) {
                                double totalAmount = incomeValue - outcomeValue;
                                HomePage.totalMoney = totalAmount;
                                return Text(
                                  '$totalAmount\$',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Container navigationBar(BuildContext context) {
    // Determine the current route to manage the active state of NavigationBar items.
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    // Define the selected index based on the current route.
    int selectedIndex = _getSelectedIndex(currentRoute);

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2), // Vertical offset
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white, // Set a background color
          height: 60.0, // Adjust the height for better touch targets
          selectedIndex: selectedIndex, // Set the selected index
          onDestinationSelected: (int index) {
            // Call a function to handle navigation when an item is selected.
            _onItemTapped(index, context);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home, size: 30.0, color: Colors.grey),
              selectedIcon: Icon(Icons.home, size: 35.0, color: primaryPurple,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart, size: 30.0, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.pie_chart, size: 35.0, color: primaryPurple),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline,
                  size: 30.0, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.add_circle, size: 35.0, color: primaryPurple),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.history, size: 30.0, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.history, size: 35.0, color: primaryPurple),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.perm_identity, size: 30.0, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.perm_identity, size: 35.0, color: primaryPurple),
              label: '',
            ),
          ],
        ));
  }

// This function returns the index of the selected navigation item based on the route name.
  int _getSelectedIndex(String currentRoute) {
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/data_visualization':
        return 1;
      case '/add':
        return 2;
      case '/history':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0; // Default to home if the route is unknown
    }
  }

// This function handles navigation when a NavigationBar item is tapped.
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/data_visualization');
        break;
      case 2:
        showDialog(
          context: context,
          builder: (context) {
            return const TrackingSelection();
          },
        );
        break;
      case 3:
        Navigator.pushNamed(context, '/history');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile_page');
        break;
    }
  }
}

class FinancialStatusCard extends StatefulWidget {
  FinancialStatusCard({
    super.key,
    required this.incomeMoneyNotifier,
    required this.outcomeMoneyNotifier,
    required this.onTotalAmountChanged,
  });
  ValueNotifier<double> incomeMoneyNotifier;
  ValueNotifier<double> outcomeMoneyNotifier;
  Function(double) onTotalAmountChanged = (double amount) {};

  @override
  State<FinancialStatusCard> createState() => _FinancialStatusCardState();
}

class _FinancialStatusCardState extends State<FinancialStatusCard> {
  late Stream<List<Expense>> _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = getAllIncomes();
    _updateValues();
  }

  void _updateValues() {
    Rx.combineLatest2(
      getAllIncomes(),
      getAllDebts(),
      (List<Expense> incomes, List<Expense> debts) {
        double totalIncome = 0.0;

        for (Expense income in incomes) {
          if (income.amount! > 0) {
            totalIncome += income.amount!;
          }
        }

        double totalDebts = 0.0;
        for (Expense debt in debts) {
          if (debt.amount! > 0) {
            totalDebts += debt.amount!;
          }
        }

        // Update the income notifier with the sum of incomes and debts
        widget.incomeMoneyNotifier.value = totalIncome + totalDebts;
        _updateOutcome();
        return null;
      },
    ).listen((_) {
      // Nothing to do here as the income notifier is already updated
    });
  }

  void _updateOutcome() {
    getAllExpenses().listen((expenses) {
      double totalAmount = expenses.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount!,
      );

      widget.outcomeMoneyNotifier.value = totalAmount;
      widget
          .onTotalAmountChanged(widget.incomeMoneyNotifier.value - totalAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF242424),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.incomeMoneyNotifier,
                  builder: (context, incomeValue, _) {
                    return financeStatusComponent(
                      const Icon(
                        Icons.arrow_downward,
                        size: 30,
                        color: Color.fromARGB(255, 18, 206, 24),
                      ),
                      "Income",
                      incomeValue,
                    );
                  },
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.outcomeMoneyNotifier,
                  builder: (context, outcomeValue, _) {
                    return financeStatusComponent(
                      const Icon(
                        Icons.arrow_upward,
                        size: 30,
                        color: Colors.red,
                      ),
                      "Outcome",
                      outcomeValue,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row financeStatusComponent(Icon icon, String title, double value) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFFF2F2F2),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$ $value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }
}
