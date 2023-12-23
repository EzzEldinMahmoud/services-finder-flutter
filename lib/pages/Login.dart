import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

var IDnumber = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'lib/assets/logo.jpg',
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('ادخل الرقم القومي',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35)),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: IDnumber,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'رجاء ادخال رقم قومي';
                              } else if (value.length > 14 ||
                                  value.length < 14) {
                                return 'رجاء ادخال رقم قومي صحيح';
                              }
                            },
                            decoration: const InputDecoration(
                                hintText: 'ادخل الرقم القومي',
                                labelText: ' الرقم القومي',
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                Navigator.pushNamed(context, '/main');
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            textDirection: TextDirection.rtl,
                                            ' برجاء الانتظار',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20))));
                              }
                            },
                            child: const Center(
                              child: Text("ادخل",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black)),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
