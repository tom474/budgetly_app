import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

enum Type { Expense, Income, Debts }

class Category {
  Category({
    required this.name,
    required this.iconData,
    required this.type,
  }) : id = uuid.v4();
  final String id;
  final String name;
  final int iconData;
  final Type type;

  Icon getIcon() {
    return Icon(
      IconData(
        iconData,
        fontFamily: 'MaterialIcons', // Assuming it's a Material icon
      ),
    );
  }
}

var categories = [
  Category(
    name: "Food & Beverage",
    iconData: Icons.fastfood.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Shopping",
    iconData: Icons.shopping_bag_sharp.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Transportation",
    iconData: Icons.motorcycle.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Bills",
    iconData: Icons.receipt.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Healthcare services",
    iconData: Icons.medical_information.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Family",
    iconData: Icons.family_restroom.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Entertainment",
    iconData: Icons.games_outlined.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Education",
    iconData: Icons.school.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Insurances",
    iconData: Icons.assignment.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Investments",
    iconData: Icons.monetization_on.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Pay Debt",
    iconData: Icons.money_off.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Goal",
    iconData: Icons.account_balance_wallet.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Other expenses",
    iconData: Icons.wallet.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Salary",
    iconData: Icons.attach_money.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Collect interest",
    iconData: Icons.insert_chart_rounded.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Incoming transfer",
    iconData: Icons.money.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Sell something",
    iconData: Icons.sell.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Other income",
    iconData: Icons.wallet_membership.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Loans",
    iconData: Icons.confirmation_number_sharp.codePoint,
    type: Type.Debts,
  ),
  Category(
    name: "Debts",
    iconData: Icons.balance.codePoint,
    type: Type.Debts,
  ),
  Category(
    name: "Other debts",
    iconData: Icons.money_off.codePoint,
    type: Type.Debts,
  )
];
