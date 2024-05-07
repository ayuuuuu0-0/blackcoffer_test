import 'package:blackcoffer_test/globalVar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // FirebaseAuth _auth = FirebaseAuth.instance;

  // getMyData() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .get()
  //       .then((results) {
  //     setState(() {
  //       userImageurl = results.data()!['userImage'];
  //       getUserName = results.data()!['userName'];
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   uid = FirebaseAuth.instance.currentUser!.uid;
  //   getMyData();
  // }

  bool showCard = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showCard = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300, // Set the width
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      // Handle filter icon press
                    },
                  ),
                  showCard
                      ? Card(
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                  'https://example.com/image.jpg'), // Replace with your image URL
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://example.com/user.jpg'), // Replace with your user image URL
                                ),
                                title: Text(
                                    'Video Title'), // Replace with your video title
                                subtitle: Text(
                                    'Video Description'), // Replace with your video description
                              ),
                              Text(
                                  'Category: Video Category'), // Replace with your video category
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
