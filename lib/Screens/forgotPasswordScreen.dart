import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testingme/Screens/OtpScreen.dart';
import 'package:testingme/Screens/loginscreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkPhoneNumber() async {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      showError('Please enter your phone number');
      return;
    }

    final url = Uri.parse('https://assignment-61518-default-rtdb.firebaseio.com/userdata.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if any user has the same phone number
        bool phoneExists = false;

        responseData.forEach((key, value) {
          if (value['phone'] == phoneNumber) {
            phoneExists = true;
          }
        });

        if (phoneExists) {
          // Proceed to send OTP
          sendOtp(phoneNumber);
        } else {
          showError('Phone number does not exist.');
        }
      } else {
        showError('Failed to check phone number. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showError('Error checking phone number: $error');
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Sign the user in (or link) with the credential
          await _auth.signInWithCredential(credential);
          // Navigate to the next screen or show a success message
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen())); // Replace with your desired screen
        },
        verificationFailed: (FirebaseAuthException e) {
          showError('Verification failed. Code: ${e.code}. Message: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to the OTP screen with verification ID
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpScreen(verificationId: verificationId),
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout
        },
      );
    } catch (error) {
      showError('Error sending OTP: $error');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Remember Password? ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text(
                    'Login!',
                    style: TextStyle(
                      color: Colors.orange, // Color for clickable text
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                width: 370,
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkPhoneNumber(); // Call the method to check phone number
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set the background color to orange
                    minimumSize: const Size(200, 50), // Set the minimum width and height
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                  ),
                  child: const Text('Send Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
