import 'dart:convert';
import 'package:easy_actions/easy_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/details.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventos.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

/*class DetailPage extends StatelessWidget {
  final PuntoDeInteres pdi;
  DetailPage({required Key key, required this.pdi}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
final topContent = Stack(
  children: <Widget>[
    Container(
        padding: EdgeInsets.only(left: 10.0),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("drive-steering-wheel.jpg"),
            fit: BoxFit.cover,
          ),
        )),
    Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.all(40.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
      child: Center(
        child: topContentText,
      ),
    ),
    Positioned(
      left: 8.0,
      top: 60.0,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    )
  ],
);


final topContentText = Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    SizedBox(height: 120.0),
    Icon(
      Icons.directions_car,
      color: Colors.white,
      size: 40.0,
    ),
    Container(
      width: 90.0,
      child: new Divider(color: Colors.green),
    ),
    SizedBox(height: 10.0),
    Text(
      lesson.title,
      style: TextStyle(color: Colors.white, fontSize: 45.0),
    ),
    SizedBox(height: 30.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 1, child: levelIndicator),
        Expanded(
            flex: 6,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  lesson.level,
                  style: TextStyle(color: Colors.white),
                ))),
        Expanded(flex: 1, child: coursePrice)
      ],
    ),
  ],
);
*/

class EventoPage extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String fechaInicio;
  final String fechaFin;
  final String enlaceWeb;
  final String ubicacion;
  final bool DIC;
  final List<dynamic> images;

  const EventoPage(
      {Key? key,
      required this.id,
      required this.nombre,
      required this.descripcion,
      required this.fechaInicio,
      required this.fechaFin,
      required this.ubicacion,
      required this.enlaceWeb,
      required this.DIC,
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


  Container isDIT() {
    return DIC
        ? Container(
            height: 50,
            margin: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(navigatorKey.currentContext!).size.width / 5,
                vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green,
            ),
            padding: EdgeInsets.only(left: 15),
            child: Text("Declarado de interés turístico",
                style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              images.isEmpty || images.length == 1 ? imagen() : carousel(),
              isDIT(),
              ubi(),
              fecha(),
              desc(),
              pagWeb(),
            ],
          ),
        ));
  }
}
