import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';

final CollectionReference usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];

  @override
  void initState() {
    getUsers();
    // getuserById();
    super.initState();
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.getDocuments();

    setState(() {
      users = snapshot.documents;
    });

    // snapshot.documents.forEach((DocumentSnapshot doc) {
    // print(doc.data);
    // print(doc.documentID);
    // print(doc.exists);
    // });
  }

  // getuserById() async {
  //   final String id = "frbAuv4sY6UgnSfClvf9";
  //   final DocumentSnapshot doc = await usersRef.document(id).get();
  //   print(doc.data);
  //   print(doc.documentID);
  //   print(doc.exists);
  // }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: FutureBuilder<QuerySnapshot>(
            future: usersRef.getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              final List<Text> children = snapshot.data.documents
                  .map((doc) => Text(doc['username']))
                  .toList();
              return Container(
                child: ListView(
                  children: children,
                ),
              );
            }));
  }
}
