import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'navBar.dart';
final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  title: const Text('Inicio'),
);
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _idToken = "";
    FirebaseAuth.instance.currentUser!
        .getIdToken()
        .then((value) => _idToken = value);
    return Scaffold(
      drawer: NavBar(),
      appBar: topAppBar,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'Bienvenido ' + FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}