import 'package:flutter/material.dart';
import 'package:personal_finance/screens/history_pages/debts_history_page.dart';
import 'package:personal_finance/screens/history_pages/expense_history_page.dart';
import 'package:personal_finance/screens/history_pages/income_history_page.dart';
import 'package:personal_finance/components/tracking_selection.dart';
import 'package:personal_finance/constants/style.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var currentView;
  onChangeView(String view) {
    setState(() {
      currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (currentView == "Expenses" || currentView == null) {
      content = const ExpenseHistory();
    } else if (currentView == "Incomes") {
      content = const IncomeHistory();
    } else if (currentView == "Debts") {
      content = const DebtHistory();
    } else {
      content = const Text("Expenses");
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, "Expenses",
                    currentView == null || currentView == "Expenses"),
                const SizedBox(
                  width: 10,
                ),
                _buildButton(context, "Incomes", currentView == "Incomes"),
                const SizedBox(
                  width: 10,
                ),
                _buildButton(context, "Debts", currentView == "Debts"),
              ],
            ),
            content,
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(context),
    );
  }

  Widget _buildButton(BuildContext context, String title, bool isSelected) {
    return Flexible(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? primaryPurple : Colors.white, // Background color
          foregroundColor:
              isSelected ? Colors.white : primaryPurple, // Text and icon color
          minimumSize: Size(MediaQuery.of(context).size.width / 3 - 16,
              48), // Adjust the width and height
        ),
        onPressed: () {
          onChangeView(title);
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
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
              selectedIcon: Icon(
                Icons.home,
                size: 35.0,
                color: primaryPurple,
              ),
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
