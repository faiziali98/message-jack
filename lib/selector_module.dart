import 'package:flutter/material.dart';
import 'package:message_jack/sms_receiver_module.dart';
import 'package:message_jack/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'message_receiver_module.dart';
import 'dart:io' show Platform;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();
  String? type = '';

  void initStore() async {
    final firstLaunch = await AppLaunch.isFirstLaunch();
    if (firstLaunch) {
      storage.delete(key: "type");
      setState(() {
        type = 'init';
      });
    } else {
      String? typeVal = await storage.read(key: "type");

      if (typeVal == null || typeVal == '') {
        typeVal = 'init';
      }

      setState(() {
        type = typeVal;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Reader'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.3,
              0.7,
            ],
            colors: [
              Colors.black,
              Color.fromARGB(255, 14, 39, 71),
            ],
          ),
        ),
        child: type == ''
            ? Container()
            : type == 'init'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Platform.isAndroid ? ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed: () {
                                setState(() {
                                  type = "0";
                                });
                                storage.write(
                                  key: "type",
                                  value: "0",
                                );
                              },
                              child: const Text('SMS Receiver'),
                            ): Container(),
                            ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed: () {
                                setState(() {
                                  type = "1";
                                });
                                storage.write(
                                  key: "type",
                                  value: "1",
                                );
                              },
                              child: const Text('Message Receiver'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : type == '0'
                    ? const SmsReceiverModule()
                    : const MessageReceiverModule(),
      ),
    );
  }
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
