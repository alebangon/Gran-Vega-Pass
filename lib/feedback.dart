import 'package:easy_actions/easy_actions.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class feedbackPage extends StatelessWidget {
  const feedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreen(),
    );
  }
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
class MainScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias'),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('resources/images/GVPASS DEFINITIVO.png',
                  fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '¿En qué podemos mejorar?',

                  style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              )
              ,
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Déjenos aquí sus sugerencias',
                    filled: true,
                  ),
                  maxLines: 5,
                  maxLength: 4096,
                  textInputAction: TextInputAction.done,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {

                    }
                    return null;
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: EasyElevatedButton(
                      label: 'Enviar',
                      onPressed: () {
                        if(_controller.text.isEmpty){
                          showAlertDialog(context, 'Error', 'Por favor, introduzca una sugerencia antes de pulsar \'Enviar\'');
                        }else{
                          Dio().post('http://217.160.209.248/api/sugerencias/', data: {
                            'texto': _controller.text,
                            'usuario': FirebaseAuth.instance.currentUser!.uid,
                            'email': FirebaseAuth.instance.currentUser!.email
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Muchas gracias por la sugerencia'),
                            ),
                          );
                          _controller.text='';
                        }

                      }

                  ))

            ],
          ),
        ),
      )

    );
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Enter your feedback here',
            filled: true,
          ),
          maxLines: 5,
          maxLength: 4096,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Send'),
          onPressed: () async {
            /**
             * Here we will add the necessary code to
             * send the entered data to the Firebase Cloud Firestore.
             */
          },
        )
      ],
    );
  }
}
