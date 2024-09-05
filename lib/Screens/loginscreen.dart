import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testingme/Screens/forgotPasswordScreen.dart';
import 'package:testingme/Screens/registerDoneScreen.dart';
import 'package:testingme/Screens/registerScreens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreens()));
  }

  Future<void> login() async {
    final url = Uri.parse('https://assignment-61518-default-rtdb.firebaseio.com/userdata.json');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = jsonDecode(response.body);
      final user = data.values.firstWhere((user) => user['email'] == emailController.text && user['password'] == passwordController.text, orElse: () => null);

      if (user != null) {
        print('Login successful!');
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Done()));
        // Navigate to the next screen or show success message
      } else {
        print('Invalid email or password');
        // Show error message
        showError('Invalid email or password');
      }
    } catch (error) {
      print('Error logging in: $error');
      // Handle error
      showError('An error occurred. Please try again.');
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
                Text('Welcome Back!',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'New User? ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: navigateToSignUp,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Center(
              child: Container(
                width: 370,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Container(
                width: 370,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffix: InkWell(
                        child: Text('Forgot?'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()));
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: login, // Call the login function on press
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(200, 50),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15),
              ),
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
