import 'package:blackcoffer_test/LoginScreen/enterOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  sendcode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message.toString());
        },
        codeSent: (String verficationid, int? resendtoken) {
          Get.to(EnterOTP(verificationid: verficationid));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
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
        children: [
          SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/blackcoffer.png',
            height: 300,
            width: 300,
          ),
          phoneText(),
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
      onPressed: () async {
        sendcode();
      },
      child: const Text('Next'),
    );
  }

  Widget phoneText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: phoneController,
        decoration: InputDecoration(
            prefix: Text('+91'),
            hintText: 'Enter Phone Number',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            )),
      ),
    );
  }
}
