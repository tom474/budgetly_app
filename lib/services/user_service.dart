import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/user_model.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<UserDetail> streamSectionItems() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('userDetails')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.take(1).toList(), // Convert to a list
      )
      .asyncMap(
    (docs) async {
      if (docs.isNotEmpty) {
        DocumentSnapshot document = docs.first; // Access the first document
        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return UserDetail(
            password: data['password'] ?? '',
            image_url: data['image_url'] ?? '',
            email: data['email'] ?? '',
            username: data['username'] ?? '',
          );
        }
      }
      throw Exception('No documents found.');
    },
  );
}
