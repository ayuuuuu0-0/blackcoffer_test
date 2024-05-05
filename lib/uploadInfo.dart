import 'package:blackcoffer_test/globalVar.dart';
import 'package:blackcoffer_test/mainTabView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;

  final signUpFormKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    try {
      if (filePath != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: filePath,
          maxHeight: 1080,
          maxWidth: 1080,
        );

        if (croppedImage != null) {
          setState(() {
            _image = File(croppedImage.path);
          });
        }
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  void _showImageDisplay() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void submitFormOnSignup() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return SnackBar(
                content: Text('Please pick an image'),
              );
            });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final User? user = _auth.currentUser;
      uid = user!.uid;

      final ref = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child(uid + '.jpg');
      await ref.putFile(_image!);
      userPhotoUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userName': userNameController.text.trim(),
        'id': uid,
        'userImage': userPhotoUrl,
        'time': DateTime.now(),
        'status': 'approved',
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainTabView()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.2,
            ),
            Text(
              'Upload User Info',
              style: TextStyle(fontFamily: 'Poppins SemiBold', fontSize: 40),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Form(
              key: signUpFormKey,
              child: InkWell(
                onTap: () {
                  _showImageDisplay();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.black54,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                          Icons.camera_enhance,
                          size: screenWidth * 0.180,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            //Image.asset('assets/images/login.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter user name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    )),
                onChanged: (value) {
                  userNameController.text = value;
                },
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            _isLoading
                ? Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : ElevatedButton(
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      submitFormOnSignup();
                    },
                  ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
