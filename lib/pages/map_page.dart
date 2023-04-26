import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:snapp_app/pages/widgets/back_button.dart';
import '../core/styles/textstyles.dart';
import '../core/values/colors.dart';
import '../core/values/dimens.dart';
import '../gen/assets.gen.dart';

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
  List<GeoPoint> geoPoints = [];
  Widget markerIcon = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 40,
  );
  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition:
        GeoPoint(latitude: 34.547949985118635, longitude: 50.810228144030944),
  );
  String distance = 'درحال محاسبه فاصله ...';
  String destAddress = '';
  String originAddress = '';
  bool states = false;
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
              SizedBox.expand(
                child: OSMFlutter(
                  controller: mapController,
                  trackMyPosition: false,
                  initZoom: 15,
                  isPicker: true,
                  // mapIsLoading: Center(
                  //   child: LoadingAnimationWidget.twoRotatingArc(
                  //       color: SolidColors.primary, size: 30),
                  // ),
                  minZoomLevel: 8,
                  maxZoomLevel: 18,
                  stepZoom: 1,
                  markerOption: MarkerOption(
                      advancedPickerMarker: MarkerIcon(
                    iconWidget: markerIcon,
                  )),
                ),
              ),
              MyBackButton(
                onPressed: () {
                  switch (currentWidgetState.last) {
                    case CurrentWidgetsStates.stateSelectOrigin:
                      break;
                    case CurrentWidgetsStates.stateSelectDestination:
                      markerIcon = SvgPicture.asset(
                        Assets.icons.origin,
                        height: 100,
                        width: 40,
                      );
                      geoPoints.removeLast();
                      setState(() {
                        currentWidgetState.removeLast();
                      });
                      break;
                    case CurrentWidgetsStates.stateRequestDriver:
                      mapController.zoomIn();
                      mapController.advancedPositionPicker();
                      mapController.removeMarker(geoPoints.last);
                      mapController.removeMarker(geoPoints.first);
                      geoPoints.removeLast();
                      markerIcon = SvgPicture.asset(
                        Assets.icons.destination,
                        height: 100,
                        width: 40,
                      );
                      setState(() {
                        currentWidgetState.removeLast();
                      });
                      break;
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
      onPressed: () async {
        GeoPoint originGeoPoint =
            await mapController.getCurrentPositionAdvancedPositionPicker();
        geoPoints.add(originGeoPoint);
        markerIcon = SvgPicture.asset(
          Assets.icons.destination,
          height: 100,
          width: 40,
        );
        setState(() {
          currentWidgetState.add(CurrentWidgetsStates.stateSelectDestination);
        });
        mapController.init();
      },
      child: Text(
        'انتخاب مبدأ',
        style: MyTextStyles.button,
      ),
    );
  }

  Widget destinationWidget() {
    return ElevatedButton(
      onPressed: () async {
        await mapController
            .getCurrentPositionAdvancedPositionPicker()
            .then((geoPoint) => geoPoints.add(geoPoint));

        mapController.cancelAdvancedPositionPicker();
        await mapController.addMarker(
          geoPoints.first,
          markerIcon: MarkerIcon(
            iconWidget: SvgPicture.asset(
              Assets.icons.origin,
              height: 100,
              width: 40,
            ),
          ),
        );
        await mapController.addMarker(
          geoPoints.last,
          markerIcon: MarkerIcon(
            iconWidget: SvgPicture.asset(
              Assets.icons.destination,
              height: 100,
              width: 40,
            ),
          ),
        );
        setState(() {
          currentWidgetState.add(CurrentWidgetsStates.stateRequestDriver);
        });
        await distance2point(geoPoints.first, geoPoints.last).then((value) {
          setState(() {
            if (value < 1000) {
              distance = 'فاصله تا مقصد ${value.toInt()} متر';
            } else {
              distance = 'فاصله تا مقصد ${value ~/ 1000} کیلومتر';
            }
          });
        });
        getAddress();
      },
      child: Text(
        'انتخاب مقصد',
        style: MyTextStyles.button,
      ),
    );
  }

  Widget requestDriverWidget() {
    mapController.zoomOut();
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimens.medium,
            ),
            color: Colors.white,
          ),
          child: Center(
              child: states
                  ? LoadingAnimationWidget.twoRotatingArc(
                      color: SolidColors.primary, size: 20)
                  : Text('آدرس مبدا : $originAddress',
                      style: MyTextStyles.bottom, textAlign: TextAlign.center)),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimens.medium,
            ),
            color: Colors.white,
          ),
          child: Center(
              child: states
                  ? LoadingAnimationWidget.twoRotatingArc(
                      color: SolidColors.primary, size: 20)
                  : Text('آدرس مقصد : $destAddress',
                      style: MyTextStyles.bottom, textAlign: TextAlign.center)),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimens.medium,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Text(distance, style: MyTextStyles.button),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'درخواست راننده',
              style: MyTextStyles.button,
            ),
          ),
        ),
      ],
    );
  }

  getAddress() async {
    try {
      setState(() {
        states = true;
      });
      await placemarkFromCoordinates(
              geoPoints.last.latitude, geoPoints.last.longitude,
              localeIdentifier: "fa")
          .then((List<Placemark> plist) {
        setState(() {
          destAddress =
              "${plist.first.locality} ${plist.first.thoroughfare} ${plist[2].name}";
        });
      });
      await placemarkFromCoordinates(
              geoPoints.first.latitude, geoPoints.first.longitude,
              localeIdentifier: "fa")
          .then((List<Placemark> plist) {
        setState(() {
          originAddress =
              "${plist.first.locality} ${plist.first.thoroughfare} ${plist[2].name}";
        });
      });
      setState(() {
        states = false;
      });
    } catch (e) {
      originAddress = 'آدرس یافت نشد';
      destAddress = 'آدرس یافت نشد';
    }
  }
}
