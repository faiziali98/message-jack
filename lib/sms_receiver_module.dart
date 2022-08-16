import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');

void createMessage(String? body, String? address) {
  messages
      .add({
        'body': body ?? "",
        'from': address ?? "Random",
      })
      .then((value) => debugPrint("User Added"))
      .catchError((error) => debugPrint("Failed to add user: $error"));
}

onBackgroundMessage(SmsMessage message) {
  createMessage(message.body, message.address);
}

class SmsReceiverModule extends StatefulWidget {
  const SmsReceiverModule({Key? key}) : super(key: key);

  @override
  _SmsReceiverModuleState createState() => _SmsReceiverModuleState();
}

class _SmsReceiverModuleState extends State<SmsReceiverModule> {
  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    createMessage(message.body, message.address);
    setState(() {
      _message = "${message.body} ${message.address}";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              Text("Listening to new messages"),
              Text("Latest received SMS: $_message"),
            ],
          ),
        ),
      ],
    );
  }
}
