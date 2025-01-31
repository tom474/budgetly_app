import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/services/goal_service.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/models/goal_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/screens/home_page/home_page.dart';
import 'package:personal_finance/constants/style.dart';

final user = FirebaseAuth.instance.currentUser;

class GoalItemDetail extends StatefulWidget {
  const GoalItemDetail({Key? key, required this.model, required this.color})
      : super(key: key);
  final GoalModel model;
  final Color color;

  @override
  _GoalItemDetailState createState() => _GoalItemDetailState();
}

class _GoalItemDetailState extends State<GoalItemDetail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController savedMoney = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    savedMoney.dispose();
  }

  void handleUpdateGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save money to complete this goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Wallet: ${HomePage.totalMoney}\$",
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 16,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: savedMoney,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Enter a number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    } else {
                      int? enteredValue = int.tryParse(value);
                      if (enteredValue == null) {
                        return 'Please enter a valid number';
                      } else if (enteredValue > HomePage.totalMoney) {
                        return 'You have exceeded the total amount of your wallet. Please enter a smaller number';
                      } else {
                        return null;
                      }
                    }
                  },
                  onSaved: (newValue) {
                    savedMoney.text = newValue!;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call a function to print "hi" with the obtained number
                onSubmit();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void onSubmit() {
    _formKey.currentState!.save();
    int number = int.tryParse(savedMoney.text) ?? 0;
    if (_formKey.currentState!.validate()) {
      setState(() {
        // update locally
        widget.model.saved += number;
        savedMoney.text = "";
      });
      // update the database
      updateGoalProcess(widget.model.goalId, widget.model.saved);
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('expenses')
          .add({
        'category':
            categories.where((element) => element.name == "Goal").first.name,
        'amount': number.toDouble(),
        'description': "Save money for ${widget.model.productName}",
        'selectedDate': DateTime.now(),
        'reminderDate': DateTime.now(),
      });
      Navigator.of(context).pop();
    } else {
      // ignore: avoid_print
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Goal", style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImageSection(widget.model.imagePath!),
                _buildContainer(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _buildInformationSection(),
                  ),
                ),
                _buildContainer(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _buildProgressSection(),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ));
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInformationSection() {
    TextStyle headingStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: grey1, // Assuming grey1 is defined
    );
    TextStyle infoStyle = TextStyle(
      fontSize: 18,
      color: black, // Assuming black is defined
      fontWeight: FontWeight.w500,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product:', style: headingStyle),
              Text('${widget.model.productName}', style: infoStyle),
              SizedBox(height: 12),
              Text('Price:', style: headingStyle),
              Text('\$${widget.model.price}', style: infoStyle),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Expected Date:', style: headingStyle),
              Text('${DateFormat('dd-MM-yyyy').format(widget.model.timeToBuy)}',
                  style: infoStyle),
              SizedBox(height: 12),
              Text('External Link:', style: headingStyle),
              Text('${widget.model.url}', style: infoStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    TextStyle headingStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: grey1, // Assuming grey1 is defined
    );
    TextStyle infoStyle = TextStyle(
      fontSize: 18,
      color: black, // Assuming black is defined
      fontWeight: FontWeight.w500,
    );

    double progress = widget.model.saved / widget.model.price;
    String progressText =
        "\$${widget.model.saved.toStringAsFixed(2)}/\$${widget.model.price.toStringAsFixed(2)} (${(progress * 100).toStringAsFixed(1)}%)";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: headingStyle),
        SizedBox(height: 4),
        Text(progressText, style: infoStyle),
        SizedBox(height: 8),
        LinearProgressIndicator(
          minHeight: 20,
          borderRadius: BorderRadius.circular(10),
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.all(8), // Define margin to match other components
      child: ElevatedButton(
        onPressed: handleUpdateGoal,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple, // Assuming primaryPurple is defined
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Update Goal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
