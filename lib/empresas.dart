import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_granvegapass/empresasDetalles.dart';
import 'package:flutter_granvegapass/empresasMapa.dart';
import 'package:flutter_granvegapass/rutaDetalles.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'puntosDeInteresDetalles.dart';
import 'dart:convert';

class Empresa {
  final int id;
  final String nombre;
  final String descripcion;
  final String firebaseuserId;
  final String sector;
  final String ubicacion;
  final String telefono;
  final String direccion;
  final String municipio;
  final String enlaceWeb;
  final List<dynamic> imagenes;
  final List<dynamic> valoraciones;

  const Empresa({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.firebaseuserId,
    required this.ubicacion,
    required this.sector,
    required this.telefono,
    required this.direccion,
    required this.municipio,
    required this.enlaceWeb,
    required this.imagenes,
    required this.valoraciones,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    /*
    var _puntos = List.generate(json.length, (index) => PuntoDeInteres(
      id: json[index]['id'],
      nombre: json[index]['nombre'],
      descripcion: json[index]['descripcion'],
      ubicacion: json[index]['ubicacion'],
      imagenes: json[index]['imagenes'],
    ));
*/
    return Empresa(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      direccion: json['direccion'],
      ubicacion: json['ubicacion'],
      firebaseuserId: json['firebaseUserId'],
      municipio: json['municipio'],
      sector: json['sector'],
      telefono: json['telefono'],
      enlaceWeb: json['enlaceWeb'],
      imagenes: json['images'],
      valoraciones: json['valoraciones'],
    );
  }
}


class EmpresasPage extends StatefulWidget {
  const EmpresasPage({Key? key}) : super(key: key);

  @override
  _EmpresasPageState createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  late Future<List<Empresa>> _future;
  List<Empresa> myData = [];
  List<Empresa> myDataUnfiltered = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _future = fetchEmpresas();
  }
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
    'municipio': 'Todos',
    'sector': 'Todos',
  };

  filter(String query) {
    List<Empresa> rutasFiltered = [];
    for (Empresa p in myDataUnfiltered) {
      if ((p.sector == configFiltro['sector'] || configFiltro['sector'] == 'Todos') &&
          (p.municipio == configFiltro['municipio'] ||
              configFiltro['municipio'] == 'Todos')  &&
          (p.nombre.toLowerCase().contains(query.toLowerCase()) ||
              p.descripcion.toLowerCase().contains(query.toLowerCase()))) {
        rutasFiltered.add(p);
      }
    } //
    //print(puntosFiltered);
    setState(() {
      myData = rutasFiltered;
    });
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

  final List<Map<String, dynamic>> _sectores = [
    {
      'value': 'Todos',
      'label': 'Todos',
    },

    {
      'value': 'agricultura',
      'label': 'Agricultura',
    },
    {
      'value': 'artesanía',
      'label': 'Artesanía',
    },
    {
      'value': 'comercio',
      'label': 'Comercio',
    },
    {
      'value': 'ganadería',
      'label': 'Ganadería',
    },
    {
      'value': 'hostelería',
      'label': 'Hostelería',
    },
    {
      'value': 'industria',
      'label': 'Industria',
    },
    {
      'value': 'servicios',
      'label': 'Servicios',
    },


  ];

  AppBar topAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: const Text('Empresas'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Filtrado'),
                content: Column(children: [
                  select('Ubicación', _ubicaciones, configFiltro['municipio'], 'municipio'),
                  select('Sector', _sectores, configFiltro['sector'], 'sector'),

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
                  ),
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
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => EmpresaMapaPage()),
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

  makeBody() {
    return Container(
      child: FutureBuilder<List<Empresa>>(
        future: _future,
/*    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,*/

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
                                      child:
                                      GestureDetector(
                                        child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(color: Colors.white),
                                              children: [
                                                TextSpan(
                                                    text:
                                                    '¿Quieres que tu empresa aparezca en nuestra aplicación? Pulsa Aquí'),
                                              ]),
                                        ),

                                        onTap: () =>
                                            launchUrl(Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScrURzNCpyS180gc0q7kgp2HOMxwUfHzi5Tu4U-S33FFwwsqw/viewform?vc=0&c=0&w=1&flr=0&usp=mail_form_link'),
                                                mode: LaunchMode.externalApplication),
                                      ),
                                    )

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
                            final id = myData[position].id;
                            final nombre = myData[position].nombre;
                            final descripcion = myData[position].descripcion;
                            final enlaceWeb = myData[position].enlaceWeb;
                            final direccion = myData[position].direccion;
                            final municipio = myData[position].municipio;
                            final sector = myData[position].sector;
                            final ubicacion = myData[position].ubicacion;
                            final telefono = myData[position].telefono;
                            final imagenes = myData[position].imagenes;
                            var imagen = "http://217.160.209.248" +
                                myData[position].imagenes[0];

                            return makeCard(
                              snapshot,
                              context,
                              id,
                              nombre,
                              descripcion,
                              enlaceWeb,
                              direccion,
                              municipio,
                              sector,
                              ubicacion,
                              telefono,
                              imagenes,
                              imagen,
                            );
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
    enlaceWeb,
    direccion,
    municipio,
    sector,
    ubicacion,
    telefono,
    imagenes,
    imagen,
  ) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        child: makeListTile(
          snapshot,
          context,
          id,
          nombre,
          descripcion,
          enlaceWeb,
          direccion,
          municipio,
          sector,
          ubicacion,
          telefono,
          imagenes,
          imagen,
        ),
      ),
    );
  }

  makeListTile(
    snapshot,
    context,
    id,
    nombre,
    descripcion,
    enlaceWeb,
    direccion,
    municipio,
    sector,
    ubicacion,
    telefono,
    imagenes,
    imagen,
  ) {
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
            builder: (context) => EmpresaPage(
              id: id,
              nombre: nombre,
              descripcion: descripcion,
              imagenes: imagenes,
              telefono: telefono,
              ubicacion: ubicacion,
              sector: sector,
              municipio: municipio,
              direccion: direccion,
              enlaceWeb: enlaceWeb,
              valoraciones: [],
            ),
          ),
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
