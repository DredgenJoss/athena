import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../utils/qr.dart';
import '../utils/request.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

double monto = 0.00;
// ignore: no_leading_underscores_for_local_identifiers
final _formKey = GlobalKey<FormState>();
final textcontroller = TextEditingController();

RequestClass req = RequestClass();
Map<String, dynamic> response = {};
String payStatus = 'PROCESSING';
bool control = false;
int limit = 100;

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    textcontroller.text = '';

    return TimerBuilder.periodic(Duration(seconds: limit), builder: (context) {
      return app();
    });
  }

  Widget app() {
    if (response['status'] != null) {
      String qr = response['data']['qrContent'].toString();
      String payid = response['data']['prepayId'].toString();
      if (!control) {
        req.post(
            url: 'http://127.0.0.1/api/module/query',
            body: {'prepayId': payid}).then(
          (value) => {
            if (value['status'] != 'FAIL' && value['data']['status'] == 'PAID')
              {
                control = true,
                setState(() {}),
              },
          },
        );
      }

      if (control) {
        return Scaffold(
          body: Center(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    Text(
                      'PAID',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrWidget(
                payId: qr,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: textcontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                  ),
                  onSaved: (value) {
                    monto = value as double;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () => {
                          if (textcontroller.text.isNotEmpty)
                            {
                              //print('data: ${textcontroller.text}'),
                              monto =
                                  double.tryParse(textcontroller.text) == null
                                      ? 0.00
                                      : double.tryParse(textcontroller.text)!,
                              req.post(
                                  url: 'http://127.0.0.1/api/module/create',
                                  body: {'orderAmount': monto}).then(
                                (value) => {
                                  if (value['status'] != 'FAIL')
                                    {
                                      response = value,
                                      setState(() {}),
                                      limit = 5,
                                    },
                                },
                              ),
                            },
                        },
                    child: const Text('Pagar')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
