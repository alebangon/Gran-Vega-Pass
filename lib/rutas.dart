import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/rutaDetalles.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'puntosDeInteresDetalles.dart';
import 'dart:convert';

class Ruta {
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
  final String puebloInicio;
  final String puebloFin;

  const Ruta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.longitud,
    required this.tipo,
    required this.tipoAcceso,
    required this.campoLibre,
    required this.dificultad,
    required this.enlaceWeb,
    required this.imagenes,
    required this.puntosGeograficos,
    required this.puebloInicio,
    required this.puebloFin,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    /*
    var _puntos = List.generate(json.length, (index) => PuntoDeInteres(
      id: json[index]['id'],
      nombre: json[index]['nombre'],
      descripcion: json[index]['descripcion'],
      ubicacion: json[index]['ubicacion'],
      imagenes: json[index]['imagenes'],
    ));
*/
    return Ruta(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      longitud: json['longitud'],
      tipo: json['tipo'],
      tipoAcceso: json['tipoAcceso'],
      campoLibre: json['campoLibre'],
      dificultad: json['dificultad'],
      enlaceWeb: json['enlaceWeb'],
      imagenes: json['images'],
      puntosGeograficos: json['puntosGeograficos'],
      puebloInicio: json['puebloInicio'],
      puebloFin: json['puebloFin'],
    );
  }
}

final _saved = <Ruta>{};
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

class RutasPage extends StatefulWidget {
  const RutasPage({Key? key}) : super(key: key);

  @override
  _RutasPageState createState() => _RutasPageState();
}

class _RutasPageState extends State<RutasPage> {
  late Future<List<Ruta>> _future;
  List<Ruta> myData = [];
  List<Ruta> myDataUnfiltered = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _future = fetchRutas();
  }

  Future<List<Ruta>> fetchRutas() async {
    //Map<String,String> headers = {"content-type": "application/json", "charset":"utf-8"};
    final response =
        await http.get(Uri.parse('http://217.160.209.248/api/rutas/'));
    if (response.statusCode == 200) {
      var res = response.body.runes.toList();
      List<dynamic> json = jsonDecode(utf8.decode(res));
      List<Ruta> rutas = List.generate(
          json.length,
          (index) => Ruta(
                id: json[index]['id'],
                nombre: json[index]['nombre'],
                descripcion: json[index]['descripcion'],
                longitud: json[index]['longitud'],
                tipo: json[index]['tipo'],
                tipoAcceso: json[index]['tipoAcceso'] is String
                    ? [json[index]['tipoAcceso']]
                    : json[index]['tipoAcceso'],
                campoLibre: json[index]['campoLibre'],
                dificultad: json[index]['dificultad'],
                enlaceWeb: json[index]['enlaceWeb'],
                imagenes: json[index]['images'],
                puntosGeograficos: json[index]['puntosGeograficos'],
                puebloInicio: json[index]['puebloInicio'],
                puebloFin: json[index]['puebloFin'],
              ));
      setState(() {
        myData = rutas;
        myDataUnfiltered = rutas;
      });
      return rutas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Ha habido un error al cargar las rutas');
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
      onSaved: (val) => print(val),
    );
  }

  Map<String, String> configFiltro = {
    'ubicacion': 'Todos',
    'tipo': 'Todos',
    'tipoAcceso': 'Todos',
    'dificultad': 'Todos',
    'puebloInicio': 'Todos',
    'puebloFin': 'Todos',
  };

  filter(String query) {
    List<Ruta> rutasFiltered = [];
    for (Ruta p in myDataUnfiltered) {
      if ((p.tipo == configFiltro['tipo'] || configFiltro['tipo'] == 'Todos') &&
          (p.tipoAcceso.contains(configFiltro['tipoAcceso']) ||
              configFiltro['tipoAcceso'] == 'Todos') &&
          (p.dificultad == configFiltro['dificultad'] ||
              configFiltro['dificultad'] == 'Todos') &&
          (p.nombre.toLowerCase().contains(query.toLowerCase()) ||
              p.descripcion.toLowerCase().contains(query.toLowerCase())) &&
          (p.puebloInicio == configFiltro['puebloInicio'] ||
              configFiltro['puebloInicio'] == 'Todos') &&
          (p.puebloFin == configFiltro['puebloFin'] ||
              configFiltro['puebloFin'] == 'Todos')) {
        rutasFiltered.add(p);
      }
    }
    //print(puntosFiltered);
    setState(() {
      myData = rutasFiltered;
    });
  }

  final List<Map<String, dynamic>> _tipoAcceso = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Pie',
      'label': 'A pie',
    },
    {
      'value': 'Bicicleta',
      'label': 'Bicicleta',
    },
    {
      'value': 'Ecuestre',
      'label': 'Ecuestre',
    },
    {
      'value': 'Kayak',
      'label': 'Kayak',
    },
    {
      'value': '4x4',
      'label': '4x4',
    },
  ];
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
      'value': 'Senderismo',
      'label': 'Senderismo',
    },
    {
      'value': 'Religiosa',
      'label': 'Religiosa',
    },
    {
      'value': 'Cultural',
      'label': 'Cultural',
    },
    {
      'value': 'Historica',
      'label': 'Historica',
    },
    {
      'value': 'Ecuestre',
      'label': 'Ecuestre',
    },
    {
      'value': 'Ciclista',
      'label': 'Ciclista',
    },
  ];
  final List<Map<String, dynamic>> _dificultades = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },
    {
      'value': 'Muy baja',
      'label': 'Muy baja',
    },
    {
      'value': 'Baja',
      'label': 'Baja',
    },
    {
      'value': 'Media',
      'label': 'Media',
    },
    {
      'value': 'Dura',
      'label': 'Difícil',
    },
    {
      'value': 'Muy Dura',
      'label': 'Muy Difícil',
    },
  ];

  AppBar topAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: const Text('Rutas'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Filtrado'),
                content: Column(children: [
                  select('Tipos', _tipos, configFiltro['tipo'], 'tipo'),
                  select('Tipo de acceso', _tipoAcceso,
                      configFiltro['tipoAcceso'], 'tipoAcceso'),
                  select('Dificultad', _dificultades,
                      configFiltro['dificultad'], 'dificultad'),
                  select('Pueblo de inicio', _ubicacionesOtro,
                      configFiltro['puebloInicio'], 'puebloInicio'),
                  select('Pueblo de fin', _ubicacionesOtro,
                      configFiltro['puebloFin'], 'puebloFin'),
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
      ],
    );
  }

  makeBody() {
    return Container(
      child: FutureBuilder<List<Ruta>>(
        future: _future,
/*    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,*/

        builder: (context, snapshot) {
          //makeCard(snapshot);
          return snapshot.hasData
              ? Column(
                  children: [
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
                            final id = myData[position].id;
                            final nombre = myData[position].nombre;
                            final descripcion = myData[position].descripcion;
                            final longitud = myData[position].longitud;
                            final tipo = myData[position].tipo;
                            final tipoAcceso = myData[position].tipoAcceso;
                            final campoLibre = myData[position].campoLibre;
                            final dificultad = myData[position].dificultad;
                            final puntosGeograficos =
                                myData[position].puntosGeograficos;
                            final enlaceWeb = myData[position].enlaceWeb;
                            final imagenes = myData[position].imagenes;
                            var imagen = "http://217.160.209.248" +
                                myData[position].imagenes[0];

                            return makeCard(
                                snapshot,
                                context,
                                id,
                                nombre,
                                descripcion,
                                imagen,
                                longitud,
                                tipo,
                                tipoAcceso,
                                campoLibre,
                                dificultad,
                                puntosGeograficos,
                                enlaceWeb,
                                imagenes);
                          }),
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  makeCard(
      snapshot,
      context,
      id,
      nombre,
      descripcion,
      imagen,
      longitud,
      tipo,
      tipoAcceso,
      campoLibre,
      dificultad,
      puntosGeograficos,
      enlaceWeb,
      imagenes) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color.fromRGBO(15, 110, 2, 1),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: makeListTile(
            snapshot,
            context,
            id,
            nombre,
            descripcion,
            imagen,
            longitud,
            tipo,
            tipoAcceso,
            campoLibre,
            dificultad,
            puntosGeograficos,
            enlaceWeb,
            imagenes),
      ),
    );
  }

  makeListTile(
      snapshot,
      context,
      id,
      nombre,
      descripcion,
      imagen,
      longitud,
      tipo,
      tipoAcceso,
      campoLibre,
      dificultad,
      puntosGeograficos,
      enlaceWeb,
      imagenes) {
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

      title: Container(
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
              builder: (context) => RutaPage(
                  id: id,
                  nombre: nombre,
                  descripcion: descripcion,
                  imagenes: imagenes,
                  longitud: longitud,
                  tipo: tipo,
                  tipoAcceso: tipoAcceso,
                  campoLibre: campoLibre,
                  dificultad: dificultad,
                  enlaceWeb: enlaceWeb,
                  puntosGeograficos: puntosGeograficos)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar(),
      body: makeBody(),
    );
  }
}
