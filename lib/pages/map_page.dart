import 'package:flutter/material.dart';
import 'package:snapp_app/pages/widgets/back_button.dart';
import '../core/values/dimens.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.blueAccent,
            ),
            MyBackButton(
              onPressed: () {},
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimens.medium),
        child: ElevatedButton(onPressed: () {}, child: const Text('')),
      ),
      extendBody: true,
    );
  }
}
