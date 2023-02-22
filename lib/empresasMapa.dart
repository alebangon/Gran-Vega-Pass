import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'empresas.dart';
import 'main.dart';
import 'puntosDeInteresDetalles.dart';
import 'MapItemsExample.dart';
import 'MenuSectionExpansionTile.dart';
import 'MapViewPinsExample.dart';
import 'puntosDeInteres.dart';



class EmpresaMapaPage extends StatefulWidget {
  const EmpresaMapaPage({Key? key}) : super(key: key);


  @override
  EmpresaMapaPageState createState() => EmpresaMapaPageState();
}
final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  title: const Text('Empresas'),
);

Future<List<Empresa>> fetchEmpresas() async {
  //Map<String,String> headers = {"content-type": "application/json", "charset":"utf-8"};
  final response =
  await http.get(Uri.parse('http://217.160.209.248/api/empresas/'));
  if (response.statusCode == 200) {
    var res = response.body.runes.toList();
    List<dynamic> json = jsonDecode(utf8.decode(res));
    List<Empresa> rutas = List.generate(
        json.length,
            (index) => Empresa(
          id: json[index]['id'],
          nombre: json[index]['nombre'],
          descripcion: json[index]['descripcion'],
          enlaceWeb: json[index]['enlaceWeb'],
          direccion: json[index]['direccion'],
          ubicacion: json[index]['ubicacion'],
          municipio: json[index]['municipio'],
          sector: json[index]['sector'],
          telefono: json[index]['telefono'],
          firebaseuserId: '',
          imagenes: json[index]['images'],
          valoraciones: json[index]['valoraciones'],
        ));

    return rutas;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Ha habido un error al cargar las empresas');
  }
}
class EmpresaMapaPageState extends State<EmpresaMapaPage> {
  MapItemsExample? _mapItemsExample;
  MapViewPinsExample? _mapViewPinsExample;
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

  _initializePuntosDeInteres() async{
    var puntos = await fetchEmpresas();
    for (var p in puntos){
      var coords = p.ubicacion.replaceAll("SRID=4326;POINT (", "").replaceAll(")", "").split(" ");

      GeoCoordinates geoCoordinates = GeoCoordinates(double.parse(coords[1]), double.parse(coords[0]));
      // Centered on location.
      _mapItemsExample?.addPhotoMapMarker(geoCoordinates, 0, 'resources/images/ic_launcher.png', p.nombre, p.descripcion, p.imagenes.first);

      // Centered on location. Shown above the photo marker to indicate the location.
      //_mapItemsExample?.addCircleMapMarker(geoCoordinates, 1);
    }

  }
  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.hybridDay, (MapError? error) {
      if (error == null) {
        _mapItemsExample = MapItemsExample(showDialogAux, hereMapController);
        _mapViewPinsExample = MapViewPinsExample(hereMapController);
        _initializePuntosDeInteres();
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
      const double distanceToEarthInMeters = 140000;
      MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
      hereMapController.camera.lookAtPointWithMeasure(GeoCoordinates(37.5, -5.7), mapMeasureZoom);
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
          //TODO: botón para ver los detalles
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
}