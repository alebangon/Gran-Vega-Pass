import 'dart:ffi';

import 'package:select_form_field/select_form_field.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'campañasDetalles.dart';
import 'eventosDetalles.dart';
import 'main.dart';
import 'preferencias.dart' as preferencias;

class Campana {
  final int id;
  final String nombre;
  final String fechaInicio;
  final String fechaFin;
  final String enlaceWeb;
  final String descripcion;
  final String ubicacion;
  final List<dynamic> images;

  const Campana({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.enlaceWeb,
    required this.descripcion,
    required this.ubicacion,
    required this.images,
  });

  factory Campana.fromJson(Map<String, dynamic> json) {
    return Campana(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      enlaceWeb: json['enlaceWeb'],
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      images: json['images'],
    );
  }
}

class CampanasPage extends StatefulWidget {
  const CampanasPage({Key? key}) : super(key: key);

  @override
  _CampanasPageState createState() => _CampanasPageState();
}

class _CampanasPageState extends State<CampanasPage> {
  List<Campana> myData = [];
  List<Campana> myDataUnfiltered = [];
  late Future<List<Campana>> _future;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _future = fetchCampanas();
  }

  Future<List<Campana>> fetchCampanas() async {
    final response =
    await http.get(Uri.parse('http://217.160.209.248/api/campañas/'));
    if (response.statusCode == 200) {
      var res = response.body.runes.toList();
      List<dynamic> json = jsonDecode(utf8.decode(res));
      List<Campana> campanas = [];
      for (var e in json) {
        //if(e['ubicacion']==preferencias.provinciaEventos||e['ubicacion']=='Todos'){
        Campana campana = Campana(
          id: e['id'],
          nombre: e['nombre'],
          fechaInicio: e['fechaInicio'],
          fechaFin: e['fechaFin'],
          enlaceWeb: e['enlaceWeb']==null?'':e['enlaceWeb'],
          descripcion: e['descripcion'],
          ubicacion: e['ubicacion'],
          images: e['images'],
        );
        campanas.add(campana);
      }
      setState(() {
        myData = campanas;
        myDataUnfiltered = campanas;
      });
      return campanas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Ha habido un error al cargar los eventos');
    }
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
    'DIT': 'Todos',
  };

  void filter(String query) {
    List<Campana> campanasFiltered = [];
    for (Campana p in myDataUnfiltered) {
      if ((p.ubicacion == configFiltro['ubicacion'] ||
          configFiltro['ubicacion'] == 'Todos' ||
          p.ubicacion == 'Todos') && (p.nombre.toLowerCase().contains(query.toLowerCase()) ||
          p.descripcion.toLowerCase().contains(query.toLowerCase()))
        ) {
        campanasFiltered.add(p);
      }
    }
    //print(puntosFiltered);
    setState(() {
      myData = campanasFiltered;
    });
  }

  makebody() {
    return Container(
      child: FutureBuilder<List<Campana>>(
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

                        final nombre = myData[position].nombre;
                        final descripcion = myData[position].descripcion;
                        final id = myData[position].id;
                        final ubicacion = myData[position].ubicacion;
                        final imagenes = myData[position].images;
                        final enlaceWeb = myData[position].enlaceWeb;
                        final fechaInicio = myData[position].fechaInicio;
                        final fechaFin = myData[position].fechaFin;

                        var imagen = "http://217.160.209.248" +
                            myData[position].images[0];
                        return makeCard(
                            snapshot,
                            context,
                            id,
                            nombre,
                            descripcion,
                            imagen,
                            ubicacion,
                            imagenes,
                            fechaInicio,
                            fechaFin,
                            enlaceWeb,);
                      }))
            ],
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  makeCard(snapshot,
      context,
      id,
      nombre,
      descripcion,
      imagen,
      ubicacion,
      imagenes,
      fechaInicio,
      fechaFin,
      enlaceWeb,) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.blueGrey,
      child: Container(
        child: makeListTile(
            snapshot,
            context,
            id,
            nombre,
            descripcion,
            imagen,
            ubicacion,
            imagenes,
            fechaInicio,
            fechaFin,
            enlaceWeb,),
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
      ubicacion,
      imagenes,
      fechaInicio,
      fechaFin,
      enlaceWeb,) {
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
      onTap: ()
      {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CampanaPage(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                ubicacion: ubicacion,
                images: imagenes,
                enlaceWeb: enlaceWeb,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
              )),
        );
      },
    );

  }
  topAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: const Text('Campañas'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Filtrado'),
                content: Column(children: [
                  select('Ubicacion', _ubicaciones, configFiltro['ubicacion'],
                      'ubicacion'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar(),
      body: makebody(),
    );
  }
}
