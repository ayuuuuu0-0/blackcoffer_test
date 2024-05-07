// import 'package:blackcoffer_test/globalVar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool showCard = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 5), () {
//       setState(() {
//         showCard = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {
//               // Handle notification icon press
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: 300, // Set the width
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(24)),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.filter_list),
//                     onPressed: () {
//                       // Handle filter icon press
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: showCard
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Image.asset(
//                                   'assets/blackcoffer.png'), // Replace with your image URL
//                             ),
//                             ListTile(
//                               leading: CircleAvatar(
//                                 backgroundImage: AssetImage(
//                                     'assets/blackcoffer.png'), // Replace with your user image URL
//                               ),
//                               title: Text(
//                                   'Video Title'), // Replace with your video title
//                               subtitle: Text(
//                                   'Video Description'), // Replace with your video description
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                   'Category: Video Category'), // Replace with your video category
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:blackcoffer_test/globalVar.dart';
import 'package:blackcoffer_test/videoView.dart';
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
      body: ListView(
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
              ],
            ),
          ),
          showCard
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoView()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                                'assets/new.jpg'), // Replace with your image URL
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/dp.jpg'), // Replace with your user image URL
                            ),
                            title: Text(
                                'Title: Testing'), // Replace with your video title
                            subtitle: Text(
                                'username: ayuuu'), // Replace with your video description
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Description: First Video\n' // Replace with your video category
                                'Category: Testing'), // Replace with your video category
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
