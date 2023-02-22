import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'navBar.dart';
import 'puntosDeInteresDetalles.dart';
import 'dart:convert';
import 'package:select_form_field/select_form_field.dart';
import 'package:easy_actions/easy_actions.dart';
//import 'preferencias.dart' as preferencias;


Map<String,String>configFiltro = {
  'ubicacion':'Todos',
  'tipo':'Todos',
  'BIC':'Si',
  'DIT':'Si',
};
class FiltrosPage extends StatefulWidget {

  const FiltrosPage({Key? key}) : super(key: key);

  @override
  _FiltrosPageState createState() => _FiltrosPageState();
}

final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  title: const Text(
    'Gran Vega Pass',
    textAlign: TextAlign.center,
  ),
);
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
final List<Map<String, dynamic>> _tipos = [
  {
    'value': 'Todos',
    'label': 'Todos',
  },
  {
    'value': 'Etnográfico',
    'label': 'Etnográfico',
  },
  {
    'value': 'Naturaleza',
    'label': 'Naturaleza',
  },
  {
    'value': 'Patrimonio',
    'label': 'Patrimonio',
  },
  {
    'value': 'Otro',
    'label': 'Otro',
  },
];
final List<Map<String, dynamic>>_siNo = [
  {
    'value': 'Si',
    'label': 'Si',
  },
  {
    'value': 'No',
    'label': 'No',
  },
];


class _FiltrosPageState extends State<FiltrosPage> {
  Map<String,String>configFiltro = {
    'ubicacion':'Todos',
    'tipo':'Todos',
    'BIC':'Si',
    'DIT':'Si',
  };
  select(label, items, initialValue, key) {
    return SelectFormField(
      type: SelectFormFieldType.dropdown,
      // or can be dialog
      initialValue: initialValue,
      icon: Icon(Icons.format_shapes),
      labelText: label,
      items: items,
      onChanged: (val) => {setState(() {
          this.configFiltro[key] = val;
      }), print(configFiltro)},
      onSaved: (val) => print(val),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: Container(
        child: Column(
          children: [
            Image.asset('resources/images/GVPASS DEFINITIVO.png', fit: BoxFit.fill),
            Expanded(
                child: Column(
                  children: [
                    Text('Preferencias de la aplicación'),
                    select('Ubicacion', _ubicaciones, configFiltro['ubicacion'], 'ubicacion'),
                    select('Tipos de Punto de Interés', _tipos, configFiltro['tipo'], 'tipo'),
                    select('¿Sólo Bien de Interés Cultural?', _siNo, configFiltro['BIC'], 'BIC'),
                    select('¿Sólo Declarados de Interés Turístico?', _siNo, configFiltro['DIT'], 'DIT'),

                  ],
                ))
          ],
        ),
      ),
    );
  }
}
