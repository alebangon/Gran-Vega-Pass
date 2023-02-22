import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_actions/easy_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/details.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:flutter_granvegapass/puntosDeInteresDetallesMapa.dart';
import 'package:url_launcher/url_launcher.dart';
import 'puntosDeInteres.dart';
import 'package:http/http.dart' as http;

import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'MapItemsExample.dart';
import 'puntosDeInteresMapa.dart' as punt;
import 'package:dio/dio.dart';


class PuntoDeInteresValoracion {
  final String usuario;
  final int val;
  final String comentario;

  PuntoDeInteresValoracion({
    required this.comentario,
    required this.usuario,
    required this.val,
  });
}
class PuntoDeInteresPage extends StatelessWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final String campoLibre;
  final String ubicacion;
  final String enlaceWeb;
  final bool BIC;
  final List<dynamic> tipo;
  final bool visitable;
  final List<dynamic> imagenes;
  final List<dynamic> valoraciones;
  final bool ordenDeMalta;
  List<PuntoDeInteresValoracion> valoracionesParsed = [];
  MapItemsExample? _mapItemsExample;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  int valoracionForm = 0;
  bool exists = false;
  late Column valoracionesBox = crearValoracion();

  PuntoDeInteresPage({
    Key? key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.campoLibre,
    required this.ubicacion,
    required this.imagenes,
    required this.enlaceWeb,
    required this.BIC,
    required this.tipo,
    required this.visitable,
    required this.valoraciones,
    required this.ordenDeMalta,
  }) : super(key: key);

  Future<List<PuntoDeInteresValoracion>> fetchValoraciones() async {
    final response = await http
        .get(Uri.parse('http://217.160.209.248/api/puntosDeInteres/'));
    if (response.statusCode == 200) {
      var res = response.body.runes.toList();
      List<dynamic> json = jsonDecode(utf8.decode(res));
      List<PuntoDeInteresValoracion> puntos = [];

      puntos = List.generate(
          json.length,
          (index) => PuntoDeInteresValoracion(
              comentario: json[index]['comentario'],
              usuario: json[index]['nombreUsuario'],
              val: json[index]['valoracion']));

      return puntos;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Ha habido un error al cargar los puntos de interés');
    }
  }

  valoraciones_values() {
    for (var v in valoraciones) {
      List<String> trozos = v.toString().split('---___///');
      PuntoDeInteresValoracion p = PuntoDeInteresValoracion(
          comentario: trozos[2], usuario: trozos[0], val: int.parse(trozos[1]));
      valoracionesParsed.add(p);
    }
    return valoracionesParsed;
  }

  imagen() {
    return Builder(
      builder: (BuildContext context) {
        double ancho = (MediaQuery.of(context).size.width) - 40;
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
          //width: ancho,
          //height: ,
          alignment: Alignment.center,
          child: FittedBox(
            child: imagenes.isEmpty
                ? Image.asset(
                    'resources/images/logo_gran_vega.png',
                  )
                : Image.network(
                    'http://217.160.209.248' + imagenes.first,
                  ),
            fit: BoxFit.fill,
          ),
          color: Colors.black12,
        );
      },
    );
  }

  CarouselSlider carousel() {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0),
      items: imagenes.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                //width: MediaQuery.of(context).size.width,
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
        padding: const EdgeInsets.all(8),
        child: Text(
          descripcion,
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.5, color: Color(0xFF6F8398)),
        ));
  }

  List<Widget> valoracion_estrellas(int val) {
    if (val == 1) {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Valoración: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
      ];
    } else if (val == 2) {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Valoración: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.star_border, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.star_border, color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.star_border, color: Colors.black),
        ),
      ];
    } else if (val == 3) {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Valoración: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
      ];
    } else if (val == 4) {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Valoración: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star_border,
            color: Colors.black,
          ),
        ),
      ];
    } else if (val == 5) {
      return [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          //child: Text("Dificultad: $dificultad | Tipo: $tipo | Longitud: $longitud km, |"),
          child: Text("Valoración: ",
              style: new TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
      ];
    }
    return ([Text('No se ha podido obtener la dificultad')]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
            //SliverAppBar(
            //  automaticallyImplyLeading: false,
            //  pinned: false,
            //  leadingWidth: 0,
            //  expandedHeight: 300,
            //  backgroundColor: Colors.white,
            //  flexibleSpace: FlexibleSpaceBar(
            //    title: imagenes.isEmpty || imagenes.length==1? imagen():carousel(),
            //    titlePadding: EdgeInsets.zero,
            //    centerTitle: true,
//
            //  ),
            //),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
              if (i == 0) {
                return imagenes.isEmpty || imagenes.length == 1
                    ? imagen()
                    : carousel();
              }
              if (i == 1 && BIC && visitable) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 5,
                          vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellowAccent,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Bien de interés cultural",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 5,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Visitable",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                );
              } else if (i == 1 && BIC && !visitable) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 5,
                          vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellowAccent,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Bien de interés cultural",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 5,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("No visitable",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                );
              } else if (i == 1 && !BIC && visitable) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 5,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Visitable",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                );
              } else if (i == 1 && !BIC && !visitable) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5,
                          right: MediaQuery.of(context).size.width / 5,
                          top: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: Text("No visitable",
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                );
              }

              if (i == 2) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          tipo.first == 'RE'
                              ? "Tipo: Etnográfico, $campoLibre"
                              : tipo.first == 'RNA'
                                  ? 'Tipo: Naturaleza, $campoLibre'
                                  : tipo.first == 'RHA'
                                      ? 'Tipo: Patrimonio, $campoLibre'
                                      : 'Tipo: Otro, $campoLibre',
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
                        padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
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
                        style: new TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    )
                  ],
                );
              }
              if (i == 3 && enlaceWeb != '') {
                return Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: EasyElevatedButton(
                    label: 'Visitar página web',
                    onPressed: () => launchUrl(Uri.parse(enlaceWeb),
                        mode: LaunchMode.externalApplication),
                  ),
                );
              }
              if (i == 4) {
                return Container(
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
                              ordenDeMalta: ordenDeMalta),
                        ),
                      );
                    },
                  ),
                );
              }
              //if (i == 5) {
              //  return valoracionesBox;
              //}
            }, childCount: 6),
            ),
          ],
        ));
  }


  crearValoracion() {
    List<Widget> vals = [];
    vals.add(valoracionMedia());
    valoraciones_values();
    valoracionesParsed
        .where((element) =>
    element.usuario.trim() ==
        FirebaseAuth.instance.currentUser?.displayName!.trim())
        .length ==
        0
        ? vals.add(cajaComentarios())
        : valoracionExiste();
    for (var v in valoracionesParsed) {
      vals.add(
        Container(
          child: Row(
            children: [
              avatar(),
              comentario(v),
            ],
          ),
          padding: EdgeInsets.only(top: 10),
        ),
      );
      vals.add(Divider());
    }
    return Column(
      children: vals,
    );
  }

  avatar() {
    return Container(
      child: CircleAvatar(
        child: ClipOval(
          child: Image.asset(
            'resources/images/Portrait_Placeholder.png',
            fit: BoxFit.cover,
          ),
        ),
        minRadius: 20,
        maxRadius: 30,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  comentario(PuntoDeInteresValoracion v) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(v.usuario),
          ),
          Row(
            children: valoracion_estrellas(v.val),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(v.comentario),
            ),
          ),
        ],
      ),
    );
  }

  valoracionExiste() {
    return '';
  }

  cajaComentarios() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Valoración',
                filled: true,
              ),
              maxLines: 5,
              maxLength: 4096,
              textInputAction: TextInputAction.done,
              validator: (String? text) {
                if (text == null || text.isEmpty) {
                  return 'Por favor, introduce una sugerencia';
                }
                return null;
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: EasyElevatedButton(
            label: 'Enviar valoración',
            onPressed: () {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text('Muchas gracias por la valoración'),
                ),
              );

              valoracionesParsed.add(PuntoDeInteresValoracion(
                  comentario: _controller.text,
                  usuario: FirebaseAuth.instance.currentUser!.displayName!,
                  val: 4));
              valoracionesBox = crearValoracion();
              Dio().post('http://217.160.209.248/api/puntoDeInteresValoracion/',
                  data: {
                    "nombreUsuario":
                        FirebaseAuth.instance.currentUser!.displayName,
                    "valoracion": 4,
                    "comentario": _controller.text,
                    "puntoDeInteres":
                        'http://217.160.209.248/api/puntosDeInteres/$id/',
                  });
              _controller.text = '';
            },
          ),
        ),
      ],
    );
  }

  valoracionMedia() {
    List<PuntoDeInteresValoracion> vals = [];
    for (var v in valoraciones) {
      List<String> trozos = v.toString().split('---___///');
      PuntoDeInteresValoracion p = PuntoDeInteresValoracion(
          comentario: trozos[2], usuario: trozos[0], val: int.parse(trozos[1]));
      vals.add(p);
    }
    double valor = 0;
    for (PuntoDeInteresValoracion v in vals) {
      valor += v.val;
    }
    String valorDouble =
        vals.length == 0 ? '0' : (valor / vals.length).toStringAsFixed(1);
    valor = valor / vals.length;
    return Row(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Valoración media: $valorDouble',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          padding: EdgeInsets.only(top: 10, left: 20),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            valor >= 0.25
                ? valor >= 0.75
                    ? Icons.star
                    : Icons.star_half
                : Icons.star_outline,
            color: valor >= 0.25 ? Colors.yellow : Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            valor >= 1.25
                ? valor >= 1.75
                    ? Icons.star
                    : Icons.star_half
                : Icons.star_outline,
            color: valor >= 1.25 ? Colors.yellow : Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            valor >= 2.25
                ? valor >= 2.75
                    ? Icons.star
                    : Icons.star_half
                : Icons.star_outline,
            color: valor >= 2.25 ? Colors.yellow : Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            valor >= 3.25
                ? valor >= 3.75
                    ? Icons.star
                    : Icons.star_half
                : Icons.star_outline,
            color: valor >= 3.25 ? Colors.yellow : Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            valor >= 4.25
                ? valor >= 4.75
                    ? Icons.star
                    : Icons.star_half
                : Icons.star_outline,
            color: valor >= 4.25 ? Colors.yellow : Colors.black,
          ),
        ),
      ],
    );
  }
}
