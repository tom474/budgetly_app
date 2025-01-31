import 'package:flutter/material.dart';
import 'package:personal_finance/services/user_service.dart';
import 'package:personal_finance/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F9),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            avatarSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'My Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // field('Name', 'Nguyen Van A'),
                  // field('Email', 'testA@gmail.com'),
                  informationSection(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<UserDetail> informationSection() {
    return StreamBuilder<UserDetail>(
      stream: streamSectionItems(),
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
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          UserDetail userDetail = snapshot.data!;
          return Column(
            children: [
              field('Name', userDetail.username),
              field('Email', userDetail.email),
            ],
          );
        }
      },
    );
  }

  Container field(String fieldName, String fieldValue) {
    return Container(
      width: double.infinity,
      // color: Colors.yellow,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 2),
            child: Text(
              fieldName,
              style: const TextStyle(
                color: Color(0xFF596D68),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.60,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]),
            child: Text(
              fieldValue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column avatarSection() {
    return Column(
      children: [
        StreamBuilder<UserDetail>(
            stream: streamSectionItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://i.ibb.co/6gj4tnC/rmit-wallpaper.jpg'),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data available');
              } else {
                UserDetail userDetail = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userDetail.image_url),
                    ),
                  ),
                );
              }
            }),
        Container(
          decoration: ShapeDecoration(
            color: const Color(0x7F0000FF),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
