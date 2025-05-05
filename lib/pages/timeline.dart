import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/search.dart';
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
  List<String> followingList = [];

  @override
  void initState() {
    // getuserById();
    // createUser();
    // updateUser();
    // deleteUser();
    super.initState();
    getTimeline();
    getFollowing();
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

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    )
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
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
