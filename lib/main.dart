import 'package:flutter/material.dart';
import 'package:snapp_app/pages/map_page.dart';

import 'core/values/colors.dart';

void main() {
  runApp(const SnappApp());
}

class SnappApp extends StatelessWidget {
  const SnappApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Snapp",
      home: const MapPage(),
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            fixedSize: const MaterialStatePropertyAll(
              Size(double.infinity, 50),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            elevation: const MaterialStatePropertyAll(0),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return SolidColors.pressed;
              }
              return SolidColors.primary;
            })),
      )),
    );
  }
}
