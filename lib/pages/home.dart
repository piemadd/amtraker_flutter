import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'dart:ui';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  PanelController _panelController = new PanelController();

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  static const String route = '/';

  //const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        color: (Colors.grey[800])!,
        body: FlutterMap(
          options: MapOptions(
              center: LatLng(39.14710270770074, -96.1962890625),
              minZoom: 1,
              zoom: 5,
              maxZoom: 14,
              maxBounds: LatLngBounds(LatLng(-19.252332, -170.619491),
                  LatLng(75.525547, -19.799181))),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://map.amtrakle.com/{z}/{x}/{y}.png"),
            MarkerLayerOptions(markers: [
              Marker(
                  point: LatLng(40.441753, -80.011476),
                  builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 48.0,
                      ),
                  height: 60),
            ]),
          ],
        ),
        panelBuilder: (sc) => _panel(sc),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState(() {
          _fabHeight =
              pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        }),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            InkWell(
              child: Column(
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                ],
              ),
              onTap: () {
                _panelController.panelPosition < 0.5
                    ? _panelController.open()
                    : _panelController.close();
                print(_panelController.panelPosition);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  "Amtrak 30 - Capitol Limited",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 36.0,
            ),
          ],
        ));
  }
}
