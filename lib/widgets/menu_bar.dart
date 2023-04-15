import 'package:family_job_board/screens/family_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/family.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';

class MyMenuBar extends StatelessWidget {

  final User user;

  const MyMenuBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName!),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              // backgroundImage: _getGravatar(user.email), todo: add gravatar
            ),
          ),
          ListTile(
            title: const Text('Home'),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: user),
                  ));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            trailing: const Icon(Icons.content_cut), //was attach_file, could use public
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: user),
                  ));
            },
          ),
          ListTile(
            title: const Text('Family Settings'),
            trailing: const Icon(Icons.settings), //was attach_file, could use public
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamilyPage(user: user),
                  ));
            },
          ),
        ],
      ),
    );
  }

}
