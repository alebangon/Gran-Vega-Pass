import 'dart:ffi';

import 'package:select_form_field/select_form_field.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'eventosDetalles.dart';
import 'main.dart';
import 'preferencias.dart' as preferencias;

class Evento {
  final int id;
  final String nombre;
  final String fechaInicio;
  final String fechaFin;
  final String enlaceWeb;
  final String descripcion;
  final String ubicacion;
  final bool DIC;
  final List<dynamic> images;

  const Evento({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.enlaceWeb,
    required this.descripcion,
    required this.ubicacion,
    required this.DIC,
    required this.images,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      enlaceWeb: json['enlaceWeb'],
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      DIC: json['DIC'],
      images: json['images'],
    );
  }
}

class EventosPage extends StatefulWidget {
  const EventosPage({Key? key}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  List<Evento> myData = [];
  List<Evento> myDataUnfiltered = [];
  late Future<List<Evento>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchEventos();
  }

  Future<List<Evento>> fetchEventos() async {
    final response =
        await http.get(Uri.parse('http://217.160.209.248/api/eventos/'));
    if (response.statusCode == 200) {
      var res = response.body.runes.toList();
      List<dynamic> json = jsonDecode(utf8.decode(res));
      List<Evento> eventos = [];
      for (var e in json) {
        //if(e['ubicacion']==preferencias.provinciaEventos||e['ubicacion']=='Todos'){
        Evento evento = Evento(
          id: e['id'],
          nombre: e['nombre'],
          fechaInicio: e['fechaInicio'],
          fechaFin: e['fechaFin'],
          enlaceWeb: e['enlaceWeb']==null?'':e['enlaceWeb'],
          descripcion: e['descripcion'],
          ubicacion: e['ubicacion'],
          DIC: e['DIC'],
          images: e['images'],
        );
        eventos.add(evento);
      }
      setState(() {
        myData = eventos;
        myDataUnfiltered = eventos;
      });
      return eventos;
      // }
      //List<Evento> eventos = List.generate(
      //    json.length,
      //    (index) => Evento(
      //          id: json[index]['id'],
      //          nombre: json[index]['nombre'],
      //          fechaInicio: json[index]['fechaInicio'],
      //          fechaFin: json[index]['fechaFin'],
      //          enlaceWeb: json[index]['enlaceWeb'],
      //          descripcion: json[index]['descripcion'],
      //          ubicacion: json[index]['ubicacion'],
      //          DIC: json[index]['DIC'],
      //          images: json[index]['images'],
      //        ));

      return eventos;
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

  void filter() {
    List<Evento> eventosFiltered = [];
    for (Evento p in myDataUnfiltered) {
      if ((p.ubicacion == configFiltro['ubicacion'] ||
              configFiltro['ubicacion'] == 'Todos' ||
              p.ubicacion == 'Todos') &&
          ((p.DIC && configFiltro['DIT'] == 'Si') ||
              (!p.DIC && configFiltro['DIT'] == 'No') ||
              configFiltro['DIT'] == 'Todos')) {
        eventosFiltered.add(p);
      }
    }
    //print(puntosFiltered);
    setState(() {
      myData = eventosFiltered;
    });
  }

  topAppBar() {
    return AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: const Text('Agenda Comarcal'),
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
                  select('Declarado de Interés Turístico', _siNo,
                      configFiltro['DIT'], 'DIT'),
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      filter(),
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

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Evento appointment = calendarAppointmentDetails.appointments.first;
    return Column(
      children: [
        //Container(
        //    width: calendarAppointmentDetails.bounds.width,
        //    height: calendarAppointmentDetails.bounds.height / 2,
        //    color: appointment.DIC? Colors.green:Colors.orange,
        //    child: const Center(
        //      child: Icon(
        //        Icons.calendar_month,
        //        color: Colors.black,
        //      ),
        //    )),
        Row(
          children: [
            //Container(
            //  width: 75,
            //  height: 75,
            //  margin: EdgeInsets.only(right: 10),
            //  child: !appointment.images.isEmpty
            //      ? Image.network(
            //          'http://217.160.209.248' + appointment.images.first)
            //      : appointment.ubicacion == 'Todos'
            //          ? Image.asset(
            //              'resources/images/LOGO_GRAN_VEGA vertical.jpg')
            //          : Image.asset(
            //              'resources/images/' + appointment.ubicacion + '.png'),
            //),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: appointment.DIC ? Colors.green : Colors.orange,
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  height: calendarAppointmentDetails.bounds.height,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      !appointment.images.isEmpty
                          ? Image.network('http://217.160.209.248' +
                              appointment.images.first)
                          : appointment.ubicacion == 'Todos'
                              ? Image.asset(
                                  'resources/images/LOGO_GRAN_VEGA vertical.jpg')
                              : Image.asset('resources/images/' +
                                  appointment.ubicacion +
                                  '.png'),
                      Expanded(
                        child: Text(
                          appointment.nombre,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 3,
                        ),
                      )
                    ],
                  )

                  //padding: new EdgeInsets.symmetric(vertical: 10.0),
                  ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: topAppBar(),
        body: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                    child: Column(
                  children: [
                    Container(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(children: [
                                Text(
                                    '(*) Evento con fecha exacta por determinar',
                                    style: TextStyle(color: Colors.white)),
                              ]),

                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'Eventos en ',
                                          style: TextStyle(color: Colors.white),
                                          children: [
                                            TextSpan(
                                                text: 'verde ',
                                                style: TextStyle(
                                                    backgroundColor:
                                                        Colors.green)),
                                            TextSpan(
                                                text:
                                                    'están Declarados de Interés Turístico')
                                          ],
                                      ),
                                    ),
                                  )
                                ],
                              )

                              //Row(children: [
//
                              //  Icon(Icons.info_outline, color: Colors.white,),
                              //  Text('Eventos en ',style: TextStyle(color: Colors.white)),
                              //  Container(
                              //    child: Text('verde',style: TextStyle(color: Colors.white)),
                              //    color: Colors.green,
                              //  ),
                              //  Text(' están Declarados de Interés Turístico===',style: TextStyle(color: Colors.white)),
                              //],)
                            ],
                          )),
                      color: Color.fromRGBO(58, 66, 86, 1.0),
                    ),
                    Expanded(
                        child: SfCalendar(
                      onTap: (CalendarTapDetails details) {
                        if (details.appointments != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventoPage(
                                    id: details.appointments![0].id,
                                    nombre: details.appointments![0].nombre,
                                    descripcion:
                                        details.appointments![0].descripcion,
                                    fechaInicio:
                                        details.appointments![0].fechaInicio,
                                    fechaFin: details.appointments![0].fechaFin,
                                    ubicacion:
                                        details.appointments![0].ubicacion,
                                    enlaceWeb:
                                        details.appointments![0].enlaceWeb,
                                    DIC: details.appointments![0].DIC,
                                    images: details.appointments[0].images)),
                          );
                        }
                      },
                      view: CalendarView.schedule,
                      firstDayOfWeek: 1,
                      appointmentBuilder: appointmentBuilder,
                      dataSource: EventoDataSource(myData),
                      scheduleViewSettings: const ScheduleViewSettings(
                          weekHeaderSettings: WeekHeaderSettings(
                            startDateFormat: '',
                            endDateFormat: '',
                          ),
                          appointmentItemHeight: 100,
                          hideEmptyScheduleWeek: true,
                          appointmentTextStyle: TextStyle(locale: Locale('es')),
                          dayHeaderSettings: DayHeaderSettings(
                            dayFormat: 'EEE',
                          ),
                          monthHeaderSettings: MonthHeaderSettings(
                            height: 100,
                            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                          )),
                    )),
                  ],
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

/*
  @override
  Future<Widget> build(BuildContext context) async {
    return Scaffold(
        appBar: topAppBar,
        body:
          Container(
            child: SfCalendar(
              view: CalendarView.schedule,
              firstDayOfWeek: 1,
              dataSource: EventoDataSource(await _getDataSource()),
            ),

          )

    );

    }*/

//Future<List<Evento>> _getDataSource() async {
//  //final List<Evento> eventos = <Evento>[];
//  final DateTime today = DateTime.now();
//  final DateTime startTime =
//      DateTime(today.year, today.month, today.day, 9, 0, 0);
//  final DateTime endTime = startTime.add(const Duration(hours: 2));
//  List<Evento> events = await fetchEventos();
//  return events;
//}

class EventoDataSource extends CalendarDataSource {
  EventoDataSource(List<Evento> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].fechaInicio);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].fechaFin);
  }

  @override
  String getSubject(int index) {
    String name = appointments![index].nombre.replaceAll('Day', 'Día');
    return name;
  }

  @override
  Color getColor(int index) {
    return appointments![index].DIC ? Colors.green : Colors.orange;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  Future<void> showDialogAux(String title, String message) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
/*
        Container(
          child: FutureBuilder<List<Evento>>(
            future: fetchEventos(),
            builder: (context, snapshot) {
              return snapshot.hasData ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, int position) {
                    final nombre = snapshot.data![position].nombre;
                    final id = snapshot.data![position].id;
                    final fechaInicio = snapshot.data![position].fechaInicio;
                    final fechaFin = snapshot.data![position].fechaFin;
                    final BIC = snapshot.data![position].BIC;
                    //return makeCard(
                    //    snapshot, context, id, nombre, descripcion, imagen);
                    return const Center(
                        child: CircularProgressIndicator());
                  }
              ):const Center(
                  child: CircularProgressIndicator());
            }
          )

        ));
*/
