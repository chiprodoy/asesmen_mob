import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          Navigator.pop(context);
          // Navigate to Home
        },
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Profile'),
        onTap: () {
          Navigator.pop(context);
          // Navigate to Profile
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
          Navigator.pop(context);
          // Navigate to Settings
        },
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () {
          Navigator.pop(context);
          // Handle logout
        },
      )
    ]));
  }
}
