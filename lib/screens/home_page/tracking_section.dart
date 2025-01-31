// ignore_for_file: unused_field, unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:personal_finance/models/goal_model.dart';
import 'package:personal_finance/models/plan_model.dart';
import 'package:personal_finance/screens/add_goal_page/goal_item_detail.dart';

Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

class TrackingSection extends StatefulWidget {
  final String sectionName;
  final List<TrackingSectionItem> items;

  const TrackingSection(
      {super.key,
      required this.sectionName,
      this.items = const <TrackingSectionItem>[]});

  @override
  State<TrackingSection> createState() => _TrackingSectionState();
}

class _TrackingSectionState extends State<TrackingSection> {
  @override
  Widget build(BuildContext context) {
    void handleViewAllGoals() {
      Navigator.pushNamed(context, '/goals');
    }

    void handleViewAllPlan() {
      Navigator.pushNamed(context, '/plans');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.sectionName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (widget.sectionName == "Saving Goal") {
                    handleViewAllGoals();
                  } else {
                    handleViewAllPlan();
                  }
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16
                  ),
                ),
              ),
            ],
          ),
          StaggeredGrid.count(
              crossAxisCount: 2,
              axisDirection: AxisDirection.down,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: widget.items),
        ],
      ),
    );
  }
}

class TrackingSectionItem extends StatefulWidget {
  const TrackingSectionItem({super.key, this.goal, this.plan});
  final GoalModel? goal;
  final Plan? plan;
  @override
  State<TrackingSectionItem> createState() => _TrackingSectionItemState();
}

class _TrackingSectionItemState extends State<TrackingSectionItem> {
  void _changeProgress(double progress) {
    // Check whether progress is is valid
    if (progress < 0 || progress > 1) {
      throw Exception('Progress must be between 0 and 1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = getRandomColor();
    Widget content;

    if (widget.plan != null) {
      content = Row(
        children: [
          Icon(
            Icons.flag,
            color: widget.plan!.priority == Priority.High
                ? Colors.red
                : widget.plan!.priority == Priority.Medium
                    ? Colors.yellow
                    : Colors.green,
          ),
          const Spacer(),
          widget.plan!.category.getIcon(),
        ],
      );

      // Align(
      //   alignment: Alignment.bottomRight,
      //   child: widget.plan!.category.getIcon(),
      // );
    } else {
      content = LinearProgressIndicator(
        value: widget.goal!.saved / widget.goal!.price ?? 0,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(color),
      );
    }

    Widget arrow = const Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Colors.grey,
    );
    if (widget.plan != null) {
      arrow = const SizedBox();
    }

    void handleViewDetailGoal() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GoalItemDetail(model: widget.goal!, color: color);
      }));
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (widget.goal != null) {
            handleViewDetailGoal();
          }
        },
        child: Ink(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.goal == null
                          ? widget.plan!.taskName
                          : widget.goal!.productName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                        color: Color(0x7F0000FF),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  arrow
                ],
              ),
              Text(
                "\$${widget.goal == null ? widget.plan!.budget : widget.goal!.price}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 8,
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
