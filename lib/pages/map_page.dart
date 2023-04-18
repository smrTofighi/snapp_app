import 'package:flutter/material.dart';
import 'package:snapp_app/pages/widgets/back_button.dart';
import '../core/styles/textstyles.dart';
import '../core/values/dimens.dart';

class CurrentWidgetsStates {
  CurrentWidgetsStates._();
  static const int stateSelectOrigin = 0;
  static const int stateSelectDestination = 1;
  static const int stateRequestDriver = 2;
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List currentWidgetState = [CurrentWidgetsStates.stateSelectOrigin];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentWidgetState.length > 1) {
          setState(() {
            currentWidgetState.removeLast();
          });
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: Colors.blueAccent,
              ),
              MyBackButton(
                onPressed: () {
                  if (currentWidgetState.length > 1) {
                    setState(() {
                      currentWidgetState.removeLast();
                    });
                  }
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.medium),
                  child: currentWidegt(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentWidegt() {
    Widget widget = originWidget();
    switch (currentWidgetState.last) {
      case CurrentWidgetsStates.stateSelectOrigin:
        widget = originWidget();
        break;
      case CurrentWidgetsStates.stateSelectDestination:
        widget = destinationWidget();
        break;
      case CurrentWidgetsStates.stateRequestDriver:
        widget = requestDriverWidget();
        break;
    }
    return widget;
  }

  Widget originWidget() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentWidgetState.add(CurrentWidgetsStates.stateSelectDestination);
        });
      },
      child: Text(
        'انتخاب مبدأ',
        style: MyTextStyles.botton,
      ),
    );
  }

  Widget destinationWidget() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentWidgetState.add(CurrentWidgetsStates.stateRequestDriver);
        });
      },
      child: Text(
        'انتخاب مقصد',
        style: MyTextStyles.botton,
      ),
    );
  }

  Widget requestDriverWidget() {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        'درخواست راننده',
        style: MyTextStyles.botton,
      ),
    );
  }
}
