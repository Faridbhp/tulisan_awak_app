import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/actions/actions.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _selectedTheme = "Light"; // Default value
  String _selectedFontSize = "Small";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Settings>(
      converter: (store) => Settings(
        store.state.theme,
        store.state.fontSize,
      ),
      builder: (context, settings) {
        _selectedTheme = settings.theme;
        _selectedFontSize = settings.fontSize;

        ColorStore colorScheme =
            _selectedTheme == 'Light' ? ColorStore.light : ColorStore.dark;
        Color lingtOrDark = colorScheme.backgroundColor;
        Color textColor = colorScheme.textColor;
        FontStore fontSize;

        switch (settings.fontSize) {
          case "Extra Small":
            fontSize = FontStore.exstraSmall;
            break;
          case "Big":
            fontSize = FontStore.big;
            break;
          default:
            fontSize = FontStore.small;
        }

        return Scaffold(
          backgroundColor: lingtOrDark,
          appBar: AppBar(
            backgroundColor: lingtOrDark,
            automaticallyImplyLeading: false,
            title: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: fontSize.fontHeader,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Open the drawer
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    'Setting',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize.fontHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          drawer: DrawerPage(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Opsi Tampilan",
                    style: TextStyle(
                      fontSize: fontSize.fontHeader,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tema",
                        style: TextStyle(
                          fontSize: fontSize.fontContent,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset:
                                  Offset(0, 1), // Offset for shadow position
                            ),
                          ],
                          color:
                              lingtOrDark, // Background color for dropdown button
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTheme, // Current selected value
                            elevation: 16, // Elevation for the dropdown menu
                            style: TextStyle(
                              color:
                                  lingtOrDark, // Text color based on the selected theme
                              fontWeight: FontWeight.w600, // Bold text
                            ),
                            dropdownColor: lingtOrDark, // Background color for dropdown items
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTheme =
                                    newValue!; // Update the selected theme
                                StoreProvider.of<AppState>(context).dispatch(
                                    ChangeThemeAction(
                                        newValue)); // Dispatch action to Redux store
                              });
                            },
                            items: <String>[
                              'Light',
                              'Dark',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            10), // Space between icon and text
                                    Text(
                                      value,
                                      style: TextStyle(
                                        color:
                                            textColor, // Conditional text color for dropdown items
                                        fontSize: fontSize.fontContent,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(), // Map the options to dropdown menu items
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Font Size",
                        style: TextStyle(
                          fontSize: fontSize.fontContent,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10), // Padding around the dropdown
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset:
                                  Offset(0, 1), // Offset for shadow position
                            ),
                          ],
                          color: lingtOrDark, // Background color for dropdown button
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFontSize, // Current selected value
                            icon: SizedBox.shrink(),
                            elevation: 16, // Elevation for the dropdown menu
                            style: TextStyle(
                              color:
                                  textColor, // Text color based on the selected theme
                              fontWeight: FontWeight.w600, // Bold text
                            ),
                            dropdownColor:
                                lingtOrDark, // Background color for dropdown items
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFontSize =
                                    newValue!; // Update the selected font size
                                StoreProvider.of<AppState>(context)
                                    .dispatch(ChangeFontSizeAction(newValue));
                              });
                            },
                            items: <String>[
                              'Big',
                              'Small',
                              'Extra Small',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            10), // Space between icon and text
                                    Text(
                                      value,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fontSize.fontContent,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(), // Map the options to dropdown menu items
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
