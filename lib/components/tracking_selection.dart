import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance/constants/style.dart';

class TrackingSelection extends StatelessWidget {
  const TrackingSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 16), // Updated padding
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            createButton(
              "assets/icons/transactions.svg",
              'Transaction',
              () {
                Navigator.pushNamed(context, '/add_expenses');
              },
            ),
            const SizedBox(height: 15),
            createButton(
              "assets/icons/weekly_plan.svg",
              'Weekly Plan',
              () {
                Navigator.pushNamed(context, '/weekly_plan_form');
              },
            ),
            const SizedBox(height: 15),
            createButton(
              "assets/icons/saving_goal.svg",
              'Saving Goal',
              () {
                Navigator.pushNamed(context, '/add_goal');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createButton(String imagePath, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              width: 50,
              height: 50,
              colorFilter: const ColorFilter.mode(primaryPurple,
                  BlendMode.srcIn), // Customize the SVG icon color
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
