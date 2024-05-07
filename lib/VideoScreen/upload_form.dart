import 'dart:io';
import 'package:blackcoffer_test/HomeScreen/homeScreen.dart';
import 'package:blackcoffer_test/globalVar.dart';
import 'package:blackcoffer_test/mainTabView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  UploadForm({required this.videoFile, required this.videoPath});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  bool isUploading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  VideoPlayerController? playerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
  }

  void fetchLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];
    locationController.text = '${placemark.locality}, ${placemark.country}';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              child: VideoPlayer(playerController!),
            ),
            SizedBox(
              height: 30,
            ),

            // Upload now btn
            // circular progress bar
            // input fields

            showProgressBar == true
                ? Container(
                    child: const SimpleCircularProgressBar(
                      progressColors: [
                        Color.fromARGB(255, 48, 32, 30),
                        Colors.green,
                        Colors.blue
                      ],
                      animationDuration: 3,
                      backColor: Colors.white38,
                    ),
                  )
                : Column(
                    children: [
                      // title
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            prefixIcon: Icon(Icons.title),
                          ),
                        ),
                      ),
                      //description
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            prefixIcon: Icon(Icons.description),
                          ),
                        ),
                      ),
                      // catergory
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: categoryController,
                          decoration: InputDecoration(
                            hintText: 'Category',
                            prefixIcon: Icon(Icons.category),
                          ),
                        ),
                      ),
                      // location
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            hintText: 'Location',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // upload button
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isUploading = true;
                            });

                            // Get the current user's ID
                            String userId =
                                FirebaseAuth.instance.currentUser!.uid;

                            // Create a unique file name for the upload
                            String fileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            // Create a reference to the file location
                            FirebaseStorage storage = FirebaseStorage.instance;
                            Reference ref =
                                storage.ref().child("videos").child(fileName);

                            // Upload the file to Firebase Storage
                            UploadTask uploadTask =
                                ref.putFile(widget.videoFile);

                            // Wait for the upload to complete
                            await uploadTask.whenComplete(() async {
                              // Get the download URL
                              String downloadUrl = await ref.getDownloadURL();

                              // Save the video details to Firestore
                              FirebaseFirestore firestore =
                                  FirebaseFirestore.instance;
                              await firestore.collection('videos').add({
                                'userId': userId,
                                'title': titleController.text,
                                'description': descriptionController.text,
                                'category': categoryController.text,
                                'location': locationController.text,
                                'videoUrl': downloadUrl,
                              });

                              // Clear the text fields
                              titleController.clear();
                              descriptionController.clear();
                              categoryController.clear();
                              locationController.clear();

                              // Show a success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Video uploaded successfully')),
                              );
                              setState(() {
                                isUploading = false;
                              });
                              Get.to(MainTabView());
                            }).catchError((error) {
                              // Show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to upload video: $error')),
                              );
                            });
                          },
                          child: Center(
                              child: isUploading
                                  ? CircularProgressIndicator() // Show a progress indicator if an upload is in progress
                                  : Text(
                                      'Upload',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    )),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// now on the home screen give me the code for fetching the videos upload in a time based manner such that there are cards which have the video 