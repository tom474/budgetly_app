import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_finance/services/user_service.dart';
import 'package:personal_finance/models/user_model.dart';
import 'package:personal_finance/constants/style.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDetail>(
      stream: streamSectionItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          UserDetail userDetail = snapshot.data!;
          return Drawer(
            child: Container(
              color: Colors
                  .white, // Set the background color for the entire drawer
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(userDetail.image_url),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://i.ibb.co/6gj4tnC/rmit-wallpaper.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: Color(0x7F0000FF),
                    ),
                    accountName: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        userDetail.username,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          ),
                      ),
                    ),
                    accountEmail: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        userDetail.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          ),
                      ),
                    ),
                  ),
                  _buildListTile(Icons.accessibility_outlined, 'About Us', () {
                    // Handle 'About Us' onTap
                  }),
                  _buildListTile(Icons.tips_and_updates_rounded, 'Tips', () {
                    // Handle 'Tips' onTap
                  }),
                  _buildListTile(Icons.pie_chart_outline_rounded, 'Chart', () {
                    Navigator.pushNamed(context, '/data_visualization');
                  }),
                  _buildListTile(Icons.settings, 'Setting', () {
                    // Handle 'Setting' onTap
                  }),
                  _buildListTile(Icons.exit_to_app_rounded, 'Exit', () {
                    FirebaseAuth.instance.signOut();
                    GoogleSignIn().signOut();
                  }),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      tileColor: Colors.white, // Set to white
      leading: Icon(icon, color: black),
      title: Text(title),
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
    );
  }
}
