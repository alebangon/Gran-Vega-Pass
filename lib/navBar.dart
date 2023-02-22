import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_granvegapass/SearchExample.dart';
import 'package:flutter_granvegapass/empresas.dart';
import 'package:flutter_granvegapass/feedback.dart';
import 'package:flutter_granvegapass/login.dart';
import 'package:flutter_granvegapass/puntosDeInteresMapa.dart';
import 'package:flutter_granvegapass/rutas.dart';
import 'package:flutter_granvegapass/temporadas.dart';
import 'anuncios.dart';
import 'campañas.dart';
import 'puntosDeInteres.dart';
import 'eventos.dart';

Drawer navBar(context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [UserAccountsDrawerHeader(
        accountName: Text(FirebaseAuth.instance.currentUser!.displayName!),
        accountEmail: Text(FirebaseAuth.instance.currentUser!.email!),
        //currentAccountPicture: CircleAvatar(
        //  child: ClipOval(
        //    child: Image.asset(
        //      'resources/images/Portrait_Placeholder.png',
        //      fit: BoxFit.cover,
        //      width: 90,
        //      height: 90,
        //    ),
        //  ),
        //),
        decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('resources/images/head-back.jpg').image
          ),
        ),
      ),
        ListTile(
          leading: const Icon(Icons.home, color: Colors.lightBlue),
          title: Text('Inicio'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month, color: Colors.lightBlue),
          title: Text('Agenda Comarcal'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventosPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.theater_comedy, color: Colors.lightBlue),
          title: Text('Oferta Cultural'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TemporadasPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_on, color: Colors.lightBlue),
          title: Text('Puntos de interés'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PuntosDeInteresPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.hiking, color: Colors.lightBlue,),
          title: Text('Rutas'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RutasPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.campaign, color: Colors.lightBlue,),
          title: Text('Campañas'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CampanasPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.business_center_sharp, color: Colors.lightBlue),
          title: Text('Empresas'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmpresasPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.feed),
          title: Text('Sugerencias'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> feedbackPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          title: Text('Cerrar sesión'),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> LoginPage()),
            );
          },
        ),
      ],
    ),
  );
}
class NavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser!=null){
      return navBar(context);
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> LoginPage()),
      );
      return Drawer();
    }
  }
}