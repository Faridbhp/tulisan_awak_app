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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80, // Adjust the size as needed
                          height: 80,
                          decoration: BoxDecoration(
                            color:
                                Colors.blue, // Background color of the circle
                            shape:
                                BoxShape.circle, // Makes the container circular
                            border: Border.all(width: 1, color: Colors.black26),
                          ),
                          alignment: Alignment
                              .center, // Centers the text inside the circle
                          child: Text(
                            "Tuwak",
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 20, // Adjust font size as needed
                              fontWeight:
                                  FontWeight.bold, // Makes the text bold
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Tulisan Awak")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
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
