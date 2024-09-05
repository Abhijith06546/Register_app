import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingme/Screens/resetScreen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter OTP')));
      return;
    }

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);

      // Navigate to the next screen or show a success message
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResetPassword())); // Replace with your desired screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP'),
            TextField(
              controller: otpController,
              decoration: InputDecoration(hintText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: verifyOtp,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
