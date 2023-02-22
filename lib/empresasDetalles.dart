import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/details.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:flutter_granvegapass/rutaMapa.dart';
import 'empresasDetallesMapa.dart';
import 'puntosDeInteres.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_actions/easy_actions.dart';

import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'MapItemsExample.dart';

class EmpresaPage extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String sector;
  final String ubicacion;
  final String telefono;
  final String direccion;
  final String municipio;
  final String enlaceWeb;
  final List<dynamic> imagenes;
  final List<dynamic> valoraciones;
  MapItemsExample? _mapItemsExample;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  int valoracionForm = 0;
  bool exists = false;

  EmpresaPage({
    Key? key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.imagenes,
    required this.enlaceWeb,
    required this.telefono,
    required this.sector,
    required this.municipio,
    required this.direccion,
    required this.valoraciones,
  }) : super(key: key);

  imagen() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
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
              width: MediaQuery.of(context).size.width,
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
              return Column(
                children: [
                  imagenes.length == 1 ? imagen() : carousel(),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            'Ubicación: $municipio',
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            'Sector: $sector',
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, bottom: 10),
                          child: Text(
                            'Detalles',
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, bottom: 30),
                        child: Text(
                          "$descripcion",
                          style:
                              new TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: EasyElevatedButton(
                          label: 'Ver en el mapa',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PuntoMapaPage(
                                  puntos: ubicacion,
                                  nombre: nombre,
                                  imagen: imagenes.first,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      enlaceWeb!=''? Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: EasyElevatedButton(
                          label: 'Visitar página web',
                          onPressed: () => launchUrl(Uri.parse(enlaceWeb),
                              mode: LaunchMode.externalApplication),
                        ),
                      ):Container(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, bottom: 10),
                          child: Text(
                            'Información de contacto',
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            telefono != null
                                ? 'Teléfono: $telefono\nDirección: $direccion'
                                : 'Dirección: $direccion',
                            style: new TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }, childCount: 1)),
          ],
        ));
  }
}
