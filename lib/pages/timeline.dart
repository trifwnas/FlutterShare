import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/post.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'home.dart';

final CollectionReference usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts;

  @override
  void initState() {
    // getuserById();
    // createUser();
    // updateUser();
    // deleteUser();
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text("No posts");
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
          onRefresh: () => getTimeline(), child: buildTimeline()),
    );
  }
}

// createUser() {
//   usersRef
//       .document("asdasda")
//       .setData({"username": "Jeff", "postsCount": 0, "isAdmin": false});
// }

// updateUser() async {
//   final doc = await usersRef.document("1LAGsB8EGK5q6A6IYoXF").get();
//   if (doc.exists) {
//     doc.reference
//         .updateData({"username": "John", "postsCount": 0, "isAdmin": false});
//   }
// }

// deleteUser() async {
//   final DocumentSnapshot doc =
//       await usersRef.document("1LAGsB8EGK5q6A6IYoXF").get();
//   if (doc.exists) {
//     doc.reference.delete();
//   }
// }

// getuserById() async {
//   final String id = "frbAuv4sY6UgnSfClvf9";
//   final DocumentSnapshot doc = await usersRef.document(id).get();
//   print(doc.data);
//   print(doc.documentID);
//   print(doc.exists);
// }

// @override
// Widget build(context) {
//   return Scaffold(
//       appBar: header(context, isAppTitle: true),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: usersRef.snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return circularProgress();
//             }
//             final List<Text> children = snapshot.data.documents
//                 .map((doc) => Text(doc['username']))
//                 .toList();
//             return Container(
//               child: ListView(
//                 children: children,
//               ),
//             );
//           }));
// }
