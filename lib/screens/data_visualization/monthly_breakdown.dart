import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/components/tracking_selection.dart';
import 'package:personal_finance/constants/style.dart';

class DataVisualizationPage extends StatefulWidget {
  const DataVisualizationPage({super.key});

  @override
  State<DataVisualizationPage> createState() => _DataVisualizationPageState();
}

class _DataVisualizationPageState extends State<DataVisualizationPage>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  late Map<String, Color> categoryColors;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // 'this' refers to TickerProviderStateMixin
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<Map<String, double>> streamExpenses(bool isCurrentMonth) {
    var now = DateTime.now();
    var firstDay;
    var lastDay;

    if (isCurrentMonth) {
      firstDay = DateTime(now.year, now.month, 1);
      lastDay = DateTime(now.year, now.month + 1, 0);
    } else {
      firstDay = DateTime(now.year, now.month - 1, 1);
      lastDay = DateTime(now.year, now.month, 0);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('expenses')
        .where('selectedDate', isGreaterThanOrEqualTo: firstDay)
        .where('selectedDate', isLessThanOrEqualTo: lastDay)
        .snapshots()
        .map((snapshot) => snapshot.docs.take(snapshot.docs.length))
        .asyncMap((docs) async {
      Map<String, double> expenseDatas = {};

      for (var doc in docs) {
        DocumentSnapshot document = await doc.reference.get();

        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (expenseDatas.containsKey(data['category'])) {
            expenseDatas[data['category']] =
                expenseDatas[data['category']]! + data['amount'];
          } else {
            expenseDatas[data['category']] = data['amount'];
          }
        }
      }

      return expenseDatas;
    });
  }

  // Get all values from the map and sum them up
  double getTotal(Map<dynamic, double> expenseData) {
    double total = 0;
    expenseData.forEach((key, value) {
      total += value;
    });
    return total;
  }

  // Create a list of colors for the chart
  final List<Color> chartColors = [
    const Color(0xFF6263fb),
    const Color(0xFFbb4fe4),
    const Color(0xFFf037c4),
    const Color(0xFFff2e9e),
    const Color(0xFFff4377),
    const Color(0xFFff6552),
    const Color(0xFFff872f),
    const Color(0xffffa600),
  ];

  int colorIndex = 0;
  Color getNextColor() {
    colorIndex++;
    if (colorIndex > chartColors.length) {
      colorIndex = 1;
    }
    return chartColors[colorIndex - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month Breakdown'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            CustomTab(text: 'Last Month', isSelected: _tabController.index == 0),
            CustomTab(text: 'This Month', isSelected: _tabController.index == 1),
          ],
          indicatorColor: Colors.transparent, // Hide the default indicator
          onTap: (index) {
            setState(() {}); // Update the UI when a tab is selected
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildExpenseView(false), // Last month
          buildExpenseView(true), // Current month
        ],
      ),
      bottomNavigationBar: navigationBar(context),
    );
  }

  Widget buildExpenseView(bool isCurrentMonth) {
    // Formatting date for display
    var now = DateTime.now();
    var displayedMonth =
        isCurrentMonth ? now : DateTime(now.year, now.month - 1);
    var monthFormatter = DateFormat('MMMM yyyy');

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isCurrentMonth ? 'Expenses This Month' : 'Expenses Last Month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              monthFormatter.format(displayedMonth),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            StreamBuilder<Map<String, double>>(
              stream: streamExpenses(isCurrentMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  final expenseData = snapshot.data!;
                  final total = getTotal(expenseData);

                  return Column(
                    children: [
                      SizedBox(
                        height: 200, // Adjust size as needed
                        child: displayPieChart(total, expenseData),
                      ),
                      ...expenseData.entries
                          .map((e) => expenseItem(e.key, e.value))
                          .toList(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayPieChart(double total, Map<String, double> expenseData) {
    // Constructing the categoryColors map
    categoryColors = Map.fromIterable(
      expenseData.keys,
      key: (item) => item,
      value: (item) => getNextColor(),
    );

    return PieChart(
      PieChartData(
        sections: expenseData.entries.map((entry) {
          final category = entry.key;
          final amount = entry.value;
          final color = categoryColors[category]!;
          final percentage = (amount / total) * 100;
          final isSmallSection =
              percentage < 10; // Adjust this threshold as needed

          return PieChartSectionData(
            color: color,
            value: amount,
            title: isSmallSection ? '' : '${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget: isSmallSection
                ? _buildBadgeWidget('${percentage.toStringAsFixed(0)}%', color)
                : null,
            badgePositionPercentageOffset: 1.2, // Adjust this value as needed
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildBadgeWidget(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLabelWidget(String category, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              percentage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget expenseItem(String category, double amount) {
    final textColor = Colors.white;
    final categoryColor = categoryColors[category] ?? Colors.grey;

    return Container(
      height: 60,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: categoryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
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

class CustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomTab({
    Key? key,
    required this.text,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0), // Rounded corners for tabs
          color: isSelected ? primaryPurple : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}