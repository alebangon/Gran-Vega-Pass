import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/anuncios.dart';
import 'package:flutter_granvegapass/main.dart';
import 'package:flutter_granvegapass/puntosDeInteresMapa.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'puntosDeInteresDetalles.dart';
import 'preferencias.dart' as preferencias;
import 'dart:convert';

class PuntoDeInteres {
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
  final String pueblo;
  final bool ordenDeMalta;

  const PuntoDeInteres({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.campoLibre,
    required this.ubicacion,
    required this.enlaceWeb,
    required this.BIC,
    required this.tipo,
    required this.visitable,
    required this.imagenes,
    required this.valoraciones,
    required this.pueblo,
    required this.ordenDeMalta,
  });

  factory PuntoDeInteres.fromJson(Map<String, dynamic> json) {
    /*
    var _puntos = List.generate(json.length, (index) => PuntoDeInteres(
      id: json[index]['id'],
      nombre: json[index]['nombre'],
      descripcion: json[index]['descripcion'],
      ubicacion: json[index]['ubicacion'],
      imagenes: json[index]['imagenes'],
    ));
*/
    return PuntoDeInteres(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      campoLibre: json['campoLibre'],
      ubicacion: json['ubicacion'],
      enlaceWeb: json['enlaceWeb'],
      BIC: json['BIC'],
      tipo: json['tipo'],
      visitable: json['visitable'],
      imagenes: json['images'],
      valoraciones: json['valoraciones'],
      pueblo: json['pueblo'],
      ordenDeMalta: json['ordenDeMalta'],
    );
  }
}

final _saved = <PuntoDeInteres>{};
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

class PuntosDeInteresPage extends StatefulWidget {
  const PuntosDeInteresPage({Key? key}) : super(key: key);

  @override
  _PuntosDeInteresPageState createState() => _PuntosDeInteresPageState();
}

class _PuntosDeInteresPageState extends State<PuntosDeInteresPage> {
  late Future<List<PuntoDeInteres>> _future;
  List<PuntoDeInteres> myData = [];
  List<PuntoDeInteres> myDataUnfiltered = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _future = fetchPuntosDeInteres();
  }

  Map<String, String> configFiltro = {
    'ubicacion': 'Todos',
    'tipo': 'Todos',
    'categoria': 'Todos',
    'BIC': 'Todos',
    'pueblo': 'Todos',
  };

  Future<List<PuntoDeInteres>> fetchPuntosDeInteres() async {
    //Map<String,String> headers = {"content-type": "application/json", "charset":"utf-8"};
    final response = await http
        .get(Uri.parse('http://217.160.209.248/api/puntosDeInteres/'));
    if (response.statusCode == 200) {
      var res = response.body.runes.toList();
      List<dynamic> json = jsonDecode(utf8.decode(res));
      List<PuntoDeInteres> puntos = [];

      puntos = List.generate(
          json.length,
          (index) => PuntoDeInteres(
                id: json[index]["id"],
                nombre: json[index]["nombre"],
                descripcion: json[index]["descripcion"],
                campoLibre: json[index]["campoLibre"],
                ubicacion: json[index]["ubicacion"],
                enlaceWeb: json[index]["enlaceWeb"],
                BIC: json[index]["BIC"],
                tipo: json[index]["tipo"] is String
                    ? [json[index]["tipo"]]
                    : json[index]["tipo"],
                visitable: json[index]["visitable"],
                imagenes: json[index]['images'],
                valoraciones: json[index]['valoraciones'],
                pueblo: json[index]['pueblo'],
                ordenDeMalta: json[index]['ordenDeMalta'],
              ));
      setState(() {
        myData = puntos;
        myDataUnfiltered = puntos;
      });
      return puntos;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Ha habido un error al cargar los puntos de interés');
    }
  }

  select(label, items, initialValue, key) {
    return SelectFormField(
      type: SelectFormFieldType.dropdown,
      // or can be dialog
      initialValue: initialValue,
      labelText: label,
      items: items,
      onChanged: (val) => {
        setState(() {
          configFiltro[key] = val;
        }),
      },

    );
  }

  final List<Map<String, dynamic>> _ubicaciones = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Alcala del Rio',
      'label': 'Alcala del Rio',
    },
    {
      'value': 'Alcolea del Rio',
      'label': 'Alcolea del Rio',
    },
    {
      'value': 'Brenes',
      'label': 'Brenes',
    },
    {
      'value': 'Burguillos',
      'label': 'Burguillos',
    },
    {
      'value': 'Cantillana',
      'label': 'Cantillana',
    },
    {
      'value': 'Guillena',
      'label': 'Guillena',
    },
    {
      'value': 'La Algaba',
      'label': 'La Algaba',
    },
    {
      'value': 'La Rinconada',
      'label': 'La Rinconada',
    },
    {
      'value': 'Lora del Rio',
      'label': 'Lora del Rio',
    },
    {
      'value': 'Penaflor',
      'label': 'Penaflor',
    },
    {
      'value': 'Tocina',
      'label': 'Tocina',
    },
    {
      'value': 'Villanueva del Rio y minas',
      'label': 'Villanueva del Rio y minas',
    },
    {
      'value': 'Villaverde del Rio',
      'label': 'Villaverde del Rio',
    },
  ];
  final List<Map<String, dynamic>> _ubicacionesOtro = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Alcala del Rio',
      'label': 'Alcala del Rio',
    },
    {
      'value': 'Alcolea del Rio',
      'label': 'Alcolea del Rio',
    },
    {
      'value': 'Brenes',
      'label': 'Brenes',
    },
    {
      'value': 'Burguillos',
      'label': 'Burguillos',
    },
    {
      'value': 'Cantillana',
      'label': 'Cantillana',
    },
    {
      'value': 'Guillena',
      'label': 'Guillena',
    },
    {
      'value': 'La Algaba',
      'label': 'La Algaba',
    },
    {
      'value': 'La Rinconada',
      'label': 'La Rinconada',
    },
    {
      'value': 'Lora del Rio',
      'label': 'Lora del Rio',
    },
    {
      'value': 'Penaflor',
      'label': 'Penaflor',
    },
    {
      'value': 'Tocina',
      'label': 'Tocina',
    },
    {
      'value': 'Villanueva del Rio y minas',
      'label': 'Villanueva del Rio y minas',
    },
    {
      'value': 'Villaverde del Rio',
      'label': 'Villaverde del Rio',
    },
    {
      'value': 'Otro',
      'label': 'Otro',
    }
  ];
  final List<Map<String, dynamic>> _tipos = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'RE',
      'label': 'Etnográfico',
    },
    {
      'value': 'RNA',
      'label': 'Naturaleza',
    },
    {
      'value': 'RHA',
      'label': 'Patrimonio',
    },
    {
      'value': 'Otro',
      'label': 'Otro',
    },
  ];
  final List<Map<String, dynamic>> _siNo = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Si',
      'label': 'Si',
    },
    {
      'value': 'No',
      'label': 'No',
    },
  ];
  final List<Map<String, dynamic>> _categoria = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Arquitectura civil',
      'label': 'Arquitectura civil',
    },
    {
      'value': 'Colonial',
      'label': 'Colonial',
    },
    {
      'value': 'Época Romana',
      'label': 'Época Romana',
    },
    {
      'value': 'Industrial',
      'label': 'Industrial',
    },
    {
      'value': 'Mudéjar',
      'label': 'Mudéjar',
    },
    {
      'value': 'Museo',
      'label': 'Museo',
    },
    {
      'value': 'Musulmán',
      'label': 'Musulmán',
    },
    {
      'value': 'Parque',
      'label': 'Parque',
    },
    {
      'value': 'Pesca deportiva',
      'label': 'Pesca deportiva',
    },
    {
      'value': 'Prehistórico',
      'label': 'Prehistórico',
    },
    {
      'value': 'Recreo',
      'label': 'Recreo',
    },
    {
      'value': 'Religioso',
      'label': 'Religioso',
    },

    {
      'value': 'Teatro',
      'label': 'Teatro',
    },
  ];
  AppBar topAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: const Text('Puntos de Interés', maxLines: 2),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Filtrado'),
                content: Column(children: [
                  select('Ubicación', _ubicaciones, configFiltro['pueblo'],
                      'pueblo'),
                  select('Tipos', _tipos, configFiltro['tipo'], 'tipo'),
                  select('Categoría', _categoria, configFiltro['categoria'], 'categoria'),
                  select('Bien de Interés Cultural', _siNo, configFiltro['BIC'],
                      'BIC'),
                  //select('Ubicación', _ubicacionesOtro, configFiltro['pueblo'],
                  //    'pueblo'),
                  //select('¿Sólo Declarados de Interés Turístico?', _siNo,
                  //    configFiltro['DIT'], 'DIT'),
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      filter(_controller.text),
                      Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  )
                ],
              ),
            ),
            child: Icon(
              Icons.settings,
              size: 26.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PuntosDeInteresMapaPage()),
              );
            },
            child: Icon(
              Icons.map,
              size: 26.0,
            ),
          ),
        ),
      ],
    );
  }

  void filter(String query) {
    List<PuntoDeInteres> puntosFiltered = [];
    for (PuntoDeInteres p in myDataUnfiltered) {
      if (
      (p.tipo.contains(configFiltro['tipo']) || configFiltro['tipo'] == 'Todos') &&
          (configFiltro['BIC'] == 'Todos' || (configFiltro['BIC'] == 'Si' && p.BIC) ||
          (configFiltro['BIC'] == 'No' && !p.BIC)) &&
              (p.nombre.toLowerCase().contains(query.toLowerCase()) ||
                  p.descripcion.toLowerCase().contains(query.toLowerCase())) &&
              (p.pueblo == configFiltro['pueblo'] ||
                  configFiltro['pueblo'] == 'Todos')&&(p.campoLibre == configFiltro['categoria'] || configFiltro['categoria']=='Todos')) {
        puntosFiltered.add(p);
      }
    }

    setState(() {
      myData = puntosFiltered;
    });
  }

  makebody() {
    return Container(
      child: FutureBuilder<List<PuntoDeInteres>>(
        future: _future,
        builder: (context, snapshot) {
          //makeCard(snapshot);
          return snapshot.hasData
              ? Column(
                  children: [
                    Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(
                                  children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                Expanded(
                                    child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                            text:
                                                'Los puntos visitables pueden estar sujetos a horarios o a cita previa. Puntos de Interés en '),
                                        TextSpan(
                                            text: 'azul oscuro',
                                            style: TextStyle(
                                                backgroundColor:
                                                    Colors.blueGrey)),
                                        TextSpan(
                                            text:
                                                ' son Bienes de Interés Cultural'),
                                      ]),
                                )),
                                //Expanded(child: Text(
                                //    'Los puntos visitables pueden estar sujetos a horarios o a cita previa. Eventos en ',
                                //    style: TextStyle(
                                //      color: Colors.white,
                                //    )),)
                              ]),
                            ],
                          )),
                      color: Color.fromRGBO(58, 66, 86, 1.0),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Buscar',
                            ),
                            onChanged: (value) => filter(value),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: myData.length,
                            itemBuilder: (_, int position) {
                              List<PuntoDeInteres> puntos = [];
                              //filter().then((value) => print(value));
                              //print(puntos);
                              //final nombre = snapshot.data![position].nombre;
                              ////final descripcion = snapshot.data![position].descripcion.length>200? snapshot.data![position].descripcion.substring(0,150)+'...':snapshot.data![position].descripcion;
                              //final descripcion = snapshot.data![position].descripcion;
                              //final campoLibre = snapshot.data![position].campoLibre;
                              //final id = snapshot.data![position].id;
                              //final ubicacion = snapshot.data![position].ubicacion;
                              //final imagenes = snapshot.data![position].imagenes;
                              //final enlaceWeb = snapshot.data![position].enlaceWeb;
                              //final BIC = snapshot.data![position].BIC;
                              //final tipo = snapshot.data![position].tipo;
                              //final visitable = snapshot.data![position].visitable;
                              //final valoraciones = snapshot.data![position].valoraciones;
                              final nombre = myData[position].nombre;
                              final descripcion = myData[position].descripcion;
                              final campoLibre = myData[position].campoLibre;
                              final id = myData[position].id;
                              final ubicacion = myData[position].ubicacion;
                              final imagenes = myData[position].imagenes;
                              final enlaceWeb = myData[position].enlaceWeb;
                              final BIC = myData[position].BIC;
                              final tipo = myData[position].tipo;
                              final visitable = myData[position].visitable;
                              final valoraciones =
                                  myData[position].valoraciones;
                              var imagen = "http://217.160.209.248" +
                                  myData[position].imagenes[0];
                              final ordenDeMalta = myData[position].ordenDeMalta;
                              return makeCard(
                                  snapshot,
                                  context,
                                  id,
                                  nombre,
                                  descripcion,
                                  campoLibre,
                                  imagen,
                                  ubicacion,
                                  imagenes,
                                  enlaceWeb,
                                  BIC,
                                  tipo,
                                  visitable,
                                  valoraciones,
                                  ordenDeMalta);
                            }))
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  makeCard(snapshot, context, id, nombre, descripcion, campoLibre, imagen,
      ubicacion, imagenes, enlaceWeb, BIC, tipo, visitable, valoraciones, ordenDeMalta) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: BIC ? Colors.blueGrey : Color.fromRGBO(17, 177, 199, 1),
      child: Container(
        child: makeListTile(
            snapshot,
            context,
            id,
            nombre,
            descripcion,
            campoLibre,
            imagen,
            ubicacion,
            imagenes,
            enlaceWeb,
            BIC,
            tipo,
            visitable,
            valoraciones,
            ordenDeMalta),
      ),
    );
  }

  makeListTile(snapshot, context, id, nombre, descripcion, campoLibre, imagen,
      ubicacion, imagenes, enlaceWeb, BIC, tipo, visitable, valoraciones, ordenDeMalta) {
    var coded = utf8.encode(nombre).toString();
    return ListTile(
      contentPadding: EdgeInsets.only(left: 5, top: 5, bottom: 10),

      leading: Container(
        padding: EdgeInsets.only(right: 4.0),
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imagen),
              fit: BoxFit.fill,
            )),
        //child: ClipOval(child: Image.network(imagen)),
        width: 60,
      ),

      title:
      Container(
        child: Text(
          nombre,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.only(right: 15),
      ),

      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Container(
        child: Text(
          descripcion,
          style: TextStyle(color: Colors.white),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,

        ),
        padding: EdgeInsets.only(right: 15),
      ),
      isThreeLine: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PuntoDeInteresPage(
                    id: id,
                    nombre: nombre,
                    descripcion: descripcion,
                    campoLibre: campoLibre,
                    ubicacion: ubicacion,
                    imagenes: imagenes,
                    enlaceWeb: enlaceWeb,
                    BIC: BIC,
                    tipo: tipo,
                    visitable: visitable,
                    valoraciones: valoraciones,
                    ordenDeMalta: ordenDeMalta,
                  )),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar(),
      body: makebody(),
    );
  }
}
