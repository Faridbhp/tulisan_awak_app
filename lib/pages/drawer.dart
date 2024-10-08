import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/pages/archive_page.dart';
import 'package:tulisan_awak_app/pages/home_page.dart';
import 'package:tulisan_awak_app/pages/setting_page.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Settings>(
      converter: (store) => Settings(
        store.state.theme,
        store.state.fontSize,
      ),
      builder: (context, storeData) {
        ColorStore colorScheme =
            storeData.theme == 'Light' ? ColorStore.light : ColorStore.dark;
        Color lingtOrDark = colorScheme.backgroundColor;
        Color textColor = colorScheme.textColor;
        double fontSize = 18;

        switch (storeData.fontSize) {
          case "Extra Small":
            fontSize = 14;
            break;
          case "Big":
            fontSize = 22;
            break;
          default:
            fontSize = 18;
        }

        return Drawer(
          // Add the drawer widget
          backgroundColor: lingtOrDark,
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
                                color: Colors
                                    .blue, // Background color of the circle
                                shape: BoxShape
                                    .circle, // Makes the container circular
                                border:
                                    Border.all(width: 1, color: Colors.black26),
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
                            Text(
                              "Tulisan Awak",
                              style: TextStyle(fontSize: fontSize),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 10),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize + 4,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: textColor,
                ),
                title: Text(
                  'Beranda',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.archive,
                  color: textColor,
                ),
                title: Text(
                  'Arsip',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ArchivePage();
                  }));
                },
              ),
              // next buat pengaturan
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: textColor,
                ),
                title: Text(
                  'Pengaturan',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SettingPage();
                  }));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
