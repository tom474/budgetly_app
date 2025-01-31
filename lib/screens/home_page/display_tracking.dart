import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/models/goal_model.dart';
import 'package:personal_finance/models/plan_model.dart';
import 'package:personal_finance/screens/home_page/tracking_section.dart';

class DisplayTracking extends StatefulWidget {
  const DisplayTracking(
      {Key? key, required this.collectionName, required this.title})
      : super(key: key);
  final String collectionName;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _DisplayTrackingState();
  }
}

class _DisplayTrackingState extends State<DisplayTracking> {
  final user = FirebaseAuth.instance.currentUser;

  Stream<List<TrackingSectionItem>> streamSectionItems(String path) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(path)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.take(4)) // Take only the first 4 documents
        .asyncMap((docs) async {
      List<TrackingSectionItem> sectionItems = [];

      for (var doc in docs) {
        DocumentSnapshot document = await doc.reference.get();

        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (path == "goals") {
            TrackingSectionItem sectionItem = TrackingSectionItem(
                goal: GoalModel(
              goalId: document.id,
              imagePath: data['imagePath'] ?? "",
              notes: data['notes'] ?? "",
              price: data['price'] ?? 0,
              saved: data['saved'] ?? 0.0,
              productName: data['productName'] ?? "",
              timeToBuy:
                  GoalModel.convertTimestampToDateTime(data['timeToBuy']),
              url: data['url'] ?? "",
            ));
            sectionItems.add(sectionItem);
          }
          if (path == "plans") {
            Plan plan = Plan(
              id: document.id,
              taskName: data['productName'],
              budget: data['price'],
              date: Plan.convertTimestampToDateTime(data['date']),
              category: categories
                  .where((element) => element.name == data['category'])
                  .first,
              priority: Plan.convertStringToPriority(data['priority']),
            );
            TrackingSectionItem sectionItem = TrackingSectionItem(plan: plan);
            sectionItems.add(sectionItem);
          }
        }
      }

      return sectionItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrackingSectionItem>>(
      stream: streamSectionItems(widget.collectionName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            // Loading data process
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Set the stroke width
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor, // Set your desired color
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        } else {
          // Display your UI using the fetched data
          List<TrackingSectionItem> sectionItems = snapshot.data!;
          return TrackingSection(
            sectionName: widget.title,
            items: sectionItems,
          );
        }
      },
    );
  }
}
