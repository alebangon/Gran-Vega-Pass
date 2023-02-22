import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'puntosDeInteresDetalles.dart';
import 'MapItemsExample.dart';
import 'MenuSectionExpansionTile.dart';
import 'MapViewPinsExample.dart';

class RutaPuntos {
  final String puntos;
  const RutaPuntos({
    required this.puntos,
});

}


class RutaMapaPage extends StatefulWidget {
  final String puntos;
  final String nombre;
  const RutaMapaPage({Key? key, required this.puntos, required this.nombre}) : super(key: key);


  @override
  RutaMapaPageState createState() => RutaMapaPageState();
}


class RutaMapaPageState extends State<RutaMapaPage> {
  MapItemsExample? _mapItemsExample;
  MapViewPinsExample? _mapViewPinsExample;

  late AppBar topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title:  Text(widget.nombre),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: HereMap(onMapCreated: _onMapCreated),

    );
  }
  void _centeredMapMarkersButtonClicked() {
    _mapItemsExample?.showCenteredMapMarkers();
  }
  void _anchoredMapMarkersButtonClicked() {
    _mapItemsExample?.showAnchoredMapMarkers();
  }

  @override
  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.hybridNight, (MapError? error) {
      if (error == null) {
        _mapItemsExample = MapItemsExample(_showDialog, hereMapController);
        var coords = widget.puntos.split(" ");
        coords.asMap().forEach((i, s) {
          List<String> lista = s.split(",");
          GeoCoordinates geoCoordinates = GeoCoordinates(double.parse(lista[1]), double.parse(lista[0]));
          if(i==0){
            _mapItemsExample?.addCircleMapMarker(geoCoordinates, 1, 'resources/images/circle_green.png');
          }else if(i==coords.length-1){
            _mapItemsExample?.addCircleMapMarker(geoCoordinates, 1, 'resources/images/circle.png');
          }else{
            _mapItemsExample?.addCircleMapMarker(geoCoordinates, 1, 'resources/images/circle_blue.png');
          }
          const double distanceToEarthInMeters = 15000;
          MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
          hereMapController.camera.lookAtPointWithMeasure(geoCoordinates, mapMeasureZoom);
        });
        for (String s in coords){

        }
        GeoCoordinates geoCoordinates = GeoCoordinates(double.parse(coords[1]), double.parse(coords[0]));

        const double distanceToEarthInMeters = 15000;
        MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
        hereMapController.camera.lookAtPointWithMeasure(geoCoordinates, mapMeasureZoom);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
        const double distanceToEarthInMeters = 15000;
        MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
        hereMapController.camera.lookAtPointWithMeasure(GeoCoordinates(37.5, -5.7), mapMeasureZoom);
      }

    });



  }
  Future<void> showDialogAux(String title, String message) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  List<Widget> _buildDrawerList(BuildContext context) {
    List<Widget> children = [];

    DrawerHeader header = DrawerHeader(
      child: Column(
        children: [
          Text(
            'HERE SDK - Map Items Example',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
    children.add(header);

    // Add MapMarker section.
    var mapMarkerTile = _buildMapMarkerExpansionTile(context);
    children.add(mapMarkerTile);

    return children;
  }
  // Build the menu entries for the MapMarker section.
  Widget _buildMapMarkerExpansionTile(BuildContext context) {
    final List<MenuSectionItem> menuItems = [
      MenuSectionItem("Anchored (2D)", _anchoredMapMarkersButtonClicked),
      MenuSectionItem("Centered (2D)", _centeredMapMarkersButtonClicked),
    ];

    return MenuSectionExpansionTile("MapMarker", menuItems);
  }
  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}