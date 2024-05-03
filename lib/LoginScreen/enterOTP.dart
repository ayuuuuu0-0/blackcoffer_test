import 'dart:developer';

import 'package:blackcoffer_test/HomeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class EnterOTP extends StatefulWidget {
  final String verificationid;

  EnterOTP({Key? key, required this.verificationid}) : super(key: key);

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  var code = '';

  signIn() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationid, smsCode: code);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => Get.offAll(HomeScreen()));
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/blackcoffer.png',
            height: 300,
            width: 300,
          ),
          textcode(),
          SizedBox(
            height: 24,
          ),
          button(),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      onPressed: () {
        signIn();
      },
      child: Text('Verify'),
    );
  }

  Widget textcode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Pinput(
          length: 6,
          onChanged: (value) {
            code = value;
          },
        ),
      ),
    );
  }
}
