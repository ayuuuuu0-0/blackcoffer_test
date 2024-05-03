import 'package:blackcoffer_test/HomeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterOTP extends StatefulWidget {
  final String verificationId;

  EnterOTP({Key? key, required this.verificationId}) : super(key: key);

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  final _otpController = TextEditingController();

  Future<void> _verifyOTP() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _otpController.text,
    );

    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              ));
      // TODO: Navigate to next screen after successful sign in
    } catch (e) {
      // TODO: Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/blackcoffer.png',
            height: 300,
            width: 300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: _verifyOTP,
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}
