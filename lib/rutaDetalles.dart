import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/details.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:flutter_granvegapass/rutaMapa.dart';
import 'puntosDeInteres.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_actions/easy_actions.dart';

import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'MapItemsExample.dart';

class RutaPage extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String longitud;
  final String tipo;
  final List<dynamic> tipoAcceso;
  final String campoLibre;
  final String dificultad;
  final String enlaceWeb;
  final String puntosGeograficos;
  final List<dynamic> imagenes;
  MapItemsExample? _mapItemsExample;

  RutaPage({Key? key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenes,
    required this.longitud,
    required this.tipo,
    required this.tipoAcceso,
    required this.campoLibre,
    required this.dificultad,
    required this.enlaceWeb,
    required this.puntosGeograficos})
      : super(key: key);

  List<Widget> tiposDeAcceso() {
    List<Widget> res = [];
    res.add(
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15, top: 10),
        child: Text("Tipos de Acceso: ",
            style: new TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),
      ),
    );
    if (tipoAcceso.contains('Pie')) {
      res.add(Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset('resources/images/excursionismo.png'),
      ));
    }
    if (tipoAcceso.contains('Bicicleta')) {
      res.add(Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset('resources/images/ciclismo.png'),
      ));
    }
    if (tipoAcceso.contains('Ecuestre')) {
      res.add(Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset('resources/images/caballo.png'),
      ));
    }
    if (tipoAcceso.contains('4x4')) {
      res.add(Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset('resources/images/4x4.png'),
      ));
    }
    if (tipoAcceso.contains('kayak')) {
      res.add(Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset('resources/images/kayak.png'),
      ));
    }
    return res;
  }

  List<Widget> dificultad_estrellas() {
    if (dificultad == 'Muy baja') {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Dificultad: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(226, 255, 51, 1),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(226, 255, 51, 1),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(226, 255, 51, 1),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(226, 255, 51, 1),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(226, 255, 51, 1),
          ),
        ),
      ];
    } else if (dificultad == 'Baja') {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Dificultad: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Colors.green,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Colors.green,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.rectangle_outlined,
              color: Colors.green),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.rectangle_outlined,
              color: Colors.green),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.rectangle_outlined,
              color: Colors.green),
        ),
      ];
    } else if (dificultad == 'Media') {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Dificultad: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 142, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 142, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 142, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(255, 142, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(255, 142, 0, 1),
          ),
        ),
      ];
    } else if (dificultad == 'Dura') {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Dificultad: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 49, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 49, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 49, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(255, 49, 0, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle_outlined,
            color: Color.fromRGBO(255, 49, 0, 1),
          ),
        ),
      ];
    } else if (dificultad == 'Muy dura') {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Dificultad: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(88, 24, 69, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(88, 24, 69, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(88, 24, 69, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(88, 24, 69, 1),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.rectangle,
            color: Color.fromRGBO(88, 24, 69, 1),
          ),
        ),
      ];
    }
    return ([Text('No se ha podido obtener la dificultad')]);
  }

  imagen() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
          padding: EdgeInsets.only(top: 0),
          child: Image.network('http://217.160.209.248' + imagenes.first),
        );
      },
    );
  }

  CarouselSlider carousel() {
    return CarouselSlider(
      options: CarouselOptions(height: 300),
      items: imagenes.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              //decoration: BoxDecoration(

              //),
              child: Image.network('http://217.160.209.248' + i),
            );
          },
        );
      }).toList(),
    );
  }

  AppBar TopAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(nombre, maxLines: 2),
    );
  }

  Container desc() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          descripcion,
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.5, color: Color(0xFF6F8398)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  if (i == 0) {
                    return Column(
                      children: [
                        imagenes.length == 1 ? imagen() : carousel(),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text("Longitud: $longitud km",
                              style: new TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Tipo: $tipo",
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  }
                  if (i == 1) {
                    return Row(
                      children: dificultad_estrellas(),
                    );
                  }
                  if (i == 2) {
                    return Row(
                      children: tiposDeAcceso(),
                    );
                  }
                  if (i == 3) {
                    return Container(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text("Información\n",
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)));
                  }
                  if (i == 4) {
                    return Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text("$descripcion",
                            style:
                            new TextStyle(fontSize: 12, color: Colors.black)));
                  }
                  if (i == 5) {
                    return Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: EasyElevatedButton(
                            label: 'Ver guía/rutómetro',
                            onPressed: () =>
                                launchUrl(Uri.parse(enlaceWeb),
                                    mode: LaunchMode.externalApplication)));
                  }
                  if (i == 6 && puntosGeograficos!='') {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: EasyElevatedButton(
                        label: 'Ver Ruta',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RutaMapaPage(
                                      puntos: puntosGeograficos,
                                      nombre: nombre,
                                    )),
                          );
                        },
                      ),
                    );
                  }
                  if (i == 7) {
                    return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Recomendaciones\n",
                            style: new TextStyle(

                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                          Container(
                            padding: EdgeInsets.only(left: 15, bottom: 30),
                            child: Text("$campoLibre",
                            style:
                            new TextStyle(fontSize: 12, color: Colors.black)))
                    ]
                  );
                }
                }, childCount: 8)),
          ],
        ));
  }
}
