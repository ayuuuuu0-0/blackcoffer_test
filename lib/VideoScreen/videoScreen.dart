import 'package:blackcoffer_test/VideoScreen/upload_form.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      displayDialogBox();
    });
  }

  getVideoDFile(ImageSource sourceImg) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);

    if (videoFile != null) {
      //video confirmation screen
      Get.to(UploadForm(
        videoFile: File(videoFile.path),
        videoPath: videoFile.path,
      ));
    }
  }

  displayDialogBox() {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    getVideoDFile(ImageSource.gallery);
                  },
                  child: Row(children: const [
                    Icon(
                      Icons.image,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Get video from gallery",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    getVideoDFile(ImageSource.camera);
                  },
                  child: Row(children: const [
                    Icon(
                      Icons.camera_alt,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Make Video from camera",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(children: const [
                    Icon(
                      Icons.cancel,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ]),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
