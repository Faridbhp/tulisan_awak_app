import 'package:flutter/material.dart';
import 'package:tulisan_awak_app/pages/archive_page.dart';
import 'package:tulisan_awak_app/pages/home_page.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add the drawer widget
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
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
            title: Text('Beranda'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.archive),
            title: Text('Arsip'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ArchivePage();
              }));
            },
          ),
          // next buat pengaturan
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Pengaturan'),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
