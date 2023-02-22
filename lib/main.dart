// @dart=2.9
// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_granvegapass/anuncios.dart';
import 'package:flutter_granvegapass/filtros.dart';
import 'package:flutter_granvegapass/puntosDeInteres.dart';
import 'details.dart';
import 'login.dart';
import 'home.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

final _router2 = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

GoRouter _router3() {
  var user = FirebaseAuth.instance.currentUser;
  if (user!=null){
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AnunciosPage(),
        ),
      ],
    );
  }else{
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
      ],
    );
  }

}
var _router = GoRouter(

  initialLocation: '/puntosdeinteres/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state){
        return StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {

            if (snapshot.data == null){
              print('login');
              return LoginPage();
            }

            else {
              User user = snapshot.data as User;
              if(empresasId.any((element) => element.firebaseUserId==user.uid)) {
                return HomePage();
              }
              print('Anuncios');
              return AnunciosPage();

            }
          },
        );
      }


    ),
    GoRoute(
        path:'/puntosdeinteres/',
        builder: (context, state) => StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              return PuntosDeInteresPage();
            }
        )
    ),
  ],
);

List<EmpresasId> empresasId = [];
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  _initializeHERESDK();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  empresasId = await fetchEmpresasId();
  runApp(MyApp());
}

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  await SDKNativeEngine.sharedInstance?.dispose();
  // Set your credentials for the HERE SDK.
  String accessKeyId = "yVHbKaRREB6UIJWt2kgKww";
  String accessKeySecret = "fhMqz8RlO6Lo-oHYdE7041VVXFRItHHzBSsoCs27CQrqnvCsVBtv_9V4LAzQ15887GPi_0y6XDXdIhxU3lE3_g";
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}
class EmpresasId {
  final dynamic firebaseUserId;

  const EmpresasId({
    this.firebaseUserId,

  });

  factory EmpresasId.fromJson(Map<String, dynamic> json) {


    return EmpresasId(
      firebaseUserId: json['firebaseUserId'],
    );
  }
}

Future<List<EmpresasId>> fetchEmpresasId() async {
  final response = await http
      .get(Uri.parse('http://217.160.209.248/api/empresas/'));
  if (response.statusCode == 200) {
    var res = response.body.runes.toList();
    List<dynamic> json = jsonDecode(utf8.decode(res));
    List<EmpresasId> empresas = List.generate(json.length, (index) => EmpresasId(
      firebaseUserId: json[index]['firebaseUserId'],));
    return empresas;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Ha habido un error al cargar las Empresas');
  }
}
final _saved = <WordPair>{};
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      title: 'Gran Vega Pass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router3(),

    );
  }
}







//-----------------------------------------------------------------------------
/*
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
                    return ListTile(
                      title: Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                      leading: Image.asset(
                        'resources/images/logo_gran_vega.png',

                      ),
                      key: UniqueKey(),
                      trailing: Icon(
                        Icons.remove_circle_outline_outlined,
                        semanticLabel: 'Remove from saved',
                      ),
                      onTap: () {
                        setState(() {
                          _saved.remove(pair);
                          Navigator.of(context).pop();
                          _pushSaved();
                  });
                },
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gran Vega Pass'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
              alignment: Alignment.centerLeft,
              ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
          ],
        ),
      body: ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final alreadySaved = _saved.contains(_suggestions[index]);
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        return ListTile(

          leading: Image.asset(
            'resources/images/logo_gran_vega.png',

          ),
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
            textAlign: TextAlign.left,
          ),
          trailing: Icon(
            alreadySaved ?  Icons.favorite:Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',

          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(_suggestions[index]);
              } else {
                _saved.add(_suggestions[index]);
              }
            });
          },
        );
      },
    )
        );
  }
}

*/