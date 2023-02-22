import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_granvegapass/anuncios.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "", _password = "", type = "login", _first_name = "", _last_name = "";
  User? user;
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
List<Widget> loginForm (){
    return <Widget>[
      Image.asset('resources/images/GVPASS DEFINITIVO.png',
          fit: BoxFit.fill),
      Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            type == "login" ? 'Iniciar sesión' : "Registrarse",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
      TextFormField(
        onSaved: (value) {
          _email = value!;
        },
        decoration: InputDecoration(labelText: 'Email'),
      ),
      TextFormField(
        onSaved: (value) {
          _password = value!;
        },
        decoration: InputDecoration(labelText: 'Contraseña'),
        obscureText: true,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (type == "login") {
                  _login();
                } else if (type == "register") {
                  _register();
                }
              }
            },
            child: Text(type == "login" ? 'Iniciar sesión' : "Registrarse")),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
            onPressed: () {
              if (type == "login")
                setState(() {
                  type = "register";
                });
              else
                setState(() {
                  type = "login";
                });
            },
            child: Text(type == "login" ? '¿No tienes cuenta? Registrate' : "Iniciar sesión")),
      )
    ];
}
  List<Widget> registerForm (){
    return <Widget>[
      Image.asset('resources/images/GVPASS DEFINITIVO.png',
          fit: BoxFit.fill),
      Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            type == "login" ? 'Iniciar sesión' : "Registrarse",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
      TextFormField(
        onSaved: (value) {
          _email = value!;
        },
        decoration: InputDecoration(labelText: 'Email'),
      ),
      TextFormField(
        onSaved: (value) {
          _password = value!;
        },
        decoration: InputDecoration(labelText: 'Contraseña'),
        obscureText: true,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Nombre"),
        onSaved: (value) {
          _first_name = value!;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Apellidos"),
        onSaved: (value) {
          _last_name = value!;
        },
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (type == "login") {
                  _login();
                } else if (type == "register") {
                  _register();
                }
              }
            },
            child: Text(type == "login" ? 'Iniciar sesión' : "Registrarse")),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
            onPressed: () {
              if (type == "login")
                setState(() {
                  type = "register";
                });
              else
                setState(() {
                  type = "login";
                });
            },
            child: Text(type == "login" ? '¿No tienes cuenta? Registrate' : "Iniciar sesión")),
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: type=='login'?loginForm():registerForm()
                ),
              ),
            )));
  }

  Future<void> _login() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          )).user;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se ha iniciado sesión como ${user!.email}'),
        ),

      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> AnunciosPage()),
      );
    } catch (e) {
      String error = e.toString();
      print(e);
      if(e.toString().contains('Given String is empty or null')){
        showAlertDialog(context, 'Error', 'Por favor, introduzca un email y contraseña válidos');
      }else if(e.toString().contains('The email address is badly formatted.')){
        showAlertDialog(context, 'Error', 'El formáto del email no es válido.');
      }else if(e.toString().contains('The password is invalid or the user does not have a password.')||e.toString().contains('There is no user record corresponding to this identifier.')){
        showAlertDialog(context, 'Error', 'Email o contraseña incorrectos.');
      }else{
        showAlertDialog(context, 'Error', 'Se ha producido un error al iniciar sesión');
      }
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,

      );
      _updateProfile();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(context, 'Error', 'La contraseña es demasiado débil');
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(context, 'Error', 'Este email ya está asociado a una cuenta');
        //ScaffoldMessenger.of(context).showSnackBar(
        //  const SnackBar(
        //    content: Text('Este correo electrónico ya está en uso'),
        //  ),
        //);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
  Future<void> _updateProfile() async {
    //can be stored locally and then network call if not available retry later
    List l = await Future.wait([
      http.put(
          Uri.parse("http://10.0.2.2:8000/api/users/" +
              FirebaseAuth.instance.currentUser!.uid +
              "/"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
            "Token " + await FirebaseAuth.instance.currentUser!.getIdToken()
          },
          body: jsonEncode({
            "first_name": _first_name,
            "last_name": _last_name,
          })),
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(_first_name + " " + _last_name)
    ]);
  }
  showAlertDialog(BuildContext context, title, content) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}