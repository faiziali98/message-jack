import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/messages.dart';

class MessageReceiverModule extends StatefulWidget {
  const MessageReceiverModule({Key? key}) : super(key: key);

  @override
  State<MessageReceiverModule> createState() => _MessageReceiverModuleState();
}

class _MessageReceiverModuleState extends State<MessageReceiverModule> {
  @override
  void initState() {
    super.initState();
  }

  Widget messageSection(Messages data) {
    String from = data.from;
    String body = data.body;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            "From: ${from}",
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.red,
            ),
          ),
        ),
        Container(
          height: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              body,
              style: new TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageRef = FirebaseFirestore.instance
        .collection('messages')
        .withConverter<Messages>(
          fromFirestore: (snapshots, _) => Messages.fromJson(snapshots.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );

    List<Widget> widgetList = [
      StreamBuilder<QuerySnapshot<Messages>>(
        stream: messageRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return messageSection(data[index].data());
            },
          );
        },
      ),
    ];

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
        child: Stack(
          children: widgetList,
        ),
      ),
    );
  }
}
