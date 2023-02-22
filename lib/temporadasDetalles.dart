import 'dart:convert';
import 'package:easy_actions/easy_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/details.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:flutter_granvegapass/puntosDeInteresDetallesMapa.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventos.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';


class TemporadaPage extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String fechaInicio;
  final String fechaFin;
  final String enlaceWeb;
  final String ubicacion;
  final String geoReferencia;
  final List<dynamic> images;

  const TemporadaPage(
      {Key? key,
        required this.id,
        required this.nombre,
        required this.descripcion,
        required this.fechaInicio,
        required this.fechaFin,
        required this.ubicacion,
        required this.enlaceWeb,
        required this.geoReferencia,
        required this.images})
      : super(key: key);

  imagen() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: !images.isEmpty
              ? Image.network('http://217.160.209.248' + images.first)
              : ubicacion == 'Todos'
              ? Image.asset('resources/images/LOGO_GRAN_VEGA vertical.jpg')
              : Image.asset('resources/images/$ubicacion.png'),
        );
      },
    );
  }

  CarouselSlider carousel() {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0),
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              //width: MediaQuery.of(context).size.width,
                height: 300,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                //decoration: BoxDecoration(

                //),
                child: Image.network('http://217.160.209.248' + i));
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
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Text(
          descripcion,
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.5, color: Color(0xFF6F8398)),
        ));
  }

  Align ubi() {
    return
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Ubicación: $ubicacion',
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.5, color: Color(0xFF6F8398)),
            )),
      );

  }

  Align fecha() {
    var fechaInicioTrozos = fechaInicio.split("-");
    var fechaInicioFormat = fechaInicioTrozos[2] +
        '/' +
        fechaInicioTrozos[1] +
        '/' +
        fechaInicioTrozos[0];
    var fechaFinTrozos = fechaFin.split("-");
    var fechaFinFormat =
        fechaFinTrozos[2] + '/' + fechaFinTrozos[1] + '/' + fechaFinTrozos[0];
    return
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              fechaInicio == fechaFin
                  ? 'Fecha: $fechaInicioFormat'
                  : 'Fecha: desde $fechaInicioFormat hasta $fechaFinFormat',
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.5, color: Color(0xFF6F8398)),
            )),
      );
  }

  Container pagWeb() {
    if(!enlaceWeb.isEmpty){
      return Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: EasyElevatedButton(
              label: 'Visitar página web',
              onPressed: () => launchUrl(Uri.parse(enlaceWeb),
                  mode: LaunchMode.externalApplication)));
    }else{
      return Container(
        padding: EdgeInsets.only(bottom: 20),
      );
    }
  }

  Container verUbicacion(context){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: EasyElevatedButton(
        label: 'Ver en el mapa',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PuntoMapaPage(
                  puntos: geoReferencia,
                  nombre: nombre,
                  imagen: 'image',
                  ordenDeMalta: false),
            ),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              images.isEmpty || images.length == 1 ? imagen() : carousel(),
              ubi(),
              fecha(),
              desc(),
              pagWeb(),
              verUbicacion(context),
            ],
          ),
        ));
  }
}
