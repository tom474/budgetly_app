import 'package:flutter/material.dart';
import 'package:personal_finance/services/goal_service.dart';
import 'package:personal_finance/models/goal_model.dart';
import 'package:personal_finance/screens/add_goal_page/goal_item.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
        title: const Text('Your Goals'),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: StreamBuilder<List<GoalModel>>(
          stream: getAllGoals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return const Text('No data available');
            }

            List<GoalModel> goals = snapshot.data!;

            return CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 90,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      GoalModel goal = goals[index];
                      // Build your goal item widget here
                      return GoalItem(model: goal);
                    },
                    childCount: goals.length,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
