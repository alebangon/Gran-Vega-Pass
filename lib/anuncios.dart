import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'navBar.dart';
import 'puntosDeInteresDetalles.dart';
import 'dart:convert';

class Anuncio {
  final int id;
  final String titulo;
  final String informacion;
  final String empresa;
  final String fecha;
  final String fechaFin;
  final dynamic imagen;

  const Anuncio({
    required this.id,
    required this.titulo,
    required this.informacion,
    required this.empresa,
    required this.fecha,
    required this.fechaFin,
    required this.imagen,
  });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    /*
    var _puntos = List.generate(json.length, (index) => PuntoDeInteres(
      id: json[index]['id'],
      nombre: json[index]['nombre'],
      descripcion: json[index]['descripcion'],
      ubicacion: json[index]['ubicacion'],
      imagenes: json[index]['imagenes'],
    ));
*/
    print(json['images']);
    return Anuncio(
      id: json['id'],
      titulo: json['titulo'],
      informacion: json['informacion'],
      empresa: json['empresa'],
      fecha: json['fecha'],
      fechaFin: json['fechaFin'],
      imagen: json['imagen'],
    );
  }
}

Future<List<Anuncio>> fetchAnuncios() async {
  //Map<String,String> headers = {"content-type": "application/json", "charset":"utf-8"};
  final response =
      await http.get(Uri.parse('http://217.160.209.248/api/anuncio/'));
  if (response.statusCode == 200) {
    var res = response.body.runes.toList();
    List<dynamic> json = jsonDecode(utf8.decode(res));

     return List.generate(
         json.length,
             (index) => Anuncio(
           id: json[index]['id'],
           titulo: json[index]['titulo'],
           informacion: json[index]['informacion'],
           empresa: json[index]['empresa'],
           fecha: json[index]['fecha'],
           fechaFin: json[index]['fechaFin'],
           imagen: json[index]['imagen'],
         ));

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Ha habido un error al cargar los puntos de interés');
  }
}

final _saved = <Anuncio>{};
final _biggerFont = const TextStyle(fontSize: 18);
/*
class PuntosDeInteresPage extends StatelessWidget {

  const PuntosDeInteresPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de interés'),

      ),
      //removed
      body: FutureBuilder<List<PuntoDeInteres>>(
        future: fetchPuntosDeInteres(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, int position) {
                final nombre = snapshot.data![position].nombre;
                final descripcion = snapshot.data![position].descripcion.length>200? snapshot.data![position].descripcion.substring(0,150)+'...':snapshot.data![position].descripcion;
                const imagen = "resources/images/logo_gran_vega.png";
                return Card(
                    child: ListTile(
                      leading: Image.asset(imagen),
                      title: Text(nombre),
                      subtitle: Text(descripcion),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PuntoDeInteresPage(id: snapshot.data![position].id,nombre: snapshot.data![position].nombre)),
                        );
                      },
                    ));
              })
              : const Center(
                child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }


}
*/

class AnunciosPage extends StatefulWidget {
  const AnunciosPage({Key? key}) : super(key: key);

  @override
  _AnunciosPageState createState() => _AnunciosPageState();
}

final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  title: const Text(
    'Gran Vega Pass',
    textAlign: TextAlign.center,
  ),
);
final makeBody = Container(
  child: FutureBuilder<List<Anuncio>>(
    future: fetchAnuncios(),
/*    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,*/

    builder: (context, snapshot) {
      //makeCard(snapshot);
      return snapshot.hasData
          ? Column(
              children: [
                Image.asset('resources/images/GVPASS DEFINITIVO.png',
                    fit: BoxFit.fill),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (_, int position) {
                      final id = snapshot.data![position].id;
                      final titulo = snapshot.data![position].titulo;
                      final informacion = snapshot.data![position].informacion;
                      final empresa = snapshot.data![position].empresa;
                      final fecha = snapshot.data![position].fecha;
                      final fechaFin = snapshot.data![position].fechaFin;
                      final imagen = snapshot.data![position].imagen;

                      return makeCard(snapshot, context, id, titulo,
                          informacion, empresa, fecha, fechaFin, imagen);
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator());
    },
  ),
);

makeCard(snapshot, context, id, titulo, informacion, empresa, fecha, fechaFin,
    imagen) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 8.0,
    color: Color.fromRGBO(64, 75, 96, .9),
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      child: makeListTile(snapshot, context, id, titulo, informacion, empresa,
          fecha, fechaFin, imagen),
    ),
  );
}

makeListTile(snapshot, context, id, titulo, informacion, empresa, fecha,
    fechaFin, imagen) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),

    title: Column(
      children: [
        Container(
          constraints: new BoxConstraints(
            minHeight: 200,
          ),

          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(imagen),
                fit: BoxFit.scaleDown,
              )),
          //child: ClipOval(child: Image.network(imagen)),

        ),
        Text(
          titulo,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    subtitle: Text(
      informacion,
      style: TextStyle(color: Colors.white),
    ),

    //onTap: ()
    //{
//
    //  Navigator.push(
    //    context,
    //    MaterialPageRoute(builder: (context) => PuntoDeInteresPage(id: id,nombre: nombre, descripcion: descripcion, ubicacion: ubicacion, imagenes: imagenes, enlaceWeb: enlaceWeb, BIC: BIC, tipo: tipo, visitable: visitable,)),
    //  );
    //},
  );
}

class _AnunciosPageState extends State<AnunciosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
