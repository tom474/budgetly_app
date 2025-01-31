import 'package:flutter/material.dart';
import 'package:personal_finance/models/goal_model.dart';
import 'dart:math';
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

class GoalItem extends StatelessWidget {
  const GoalItem({Key? key, required this.model}) : super(key: key);
  final GoalModel model;
  @override
  Widget build(BuildContext context) {
    final Color color = getRandomColor();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.black.withOpacity(0.4),
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GoalItemDetail(model: model, color: color);
            }));
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
                        model.productName,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Text(
                  "\$${model.price.toStringAsFixed(2)}",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                LinearProgressIndicator(
                  value: model.saved / model.price,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
