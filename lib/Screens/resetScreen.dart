import 'dart:convert'; // Import this for JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'loginscreen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final newPasswordController = TextEditingController();
  final reenterPasswordController = TextEditingController();
  String errorMessage = '';

  Future<void> resetPassword() async {
    final String userId = "-O5rfdg3RSb6hArkhzT4"; // Ensure this is the correct user ID
    final String url = 'https://assignment-61518-default-rtdb.firebaseio.com/userdata/$userId.json'; // Correct URL to access the user data

    // Updated data
    final updatedData = {
      "password": newPasswordController.text.trim(),
      // Include other fields as needed
    };

    try {
      // Update the user's password using a PUT request
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print('Password updated successfully.');
        // Navigate to the login screen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        print('Failed to update password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Log the response for debugging
      }
    } catch (error) {
      print('Error updating password: $error');
    }
  }

  void validateAndSubmit() {
    setState(() {
      errorMessage = ''; // Reset error message
    });

    if (newPasswordController.text.trim() != reenterPasswordController.text.trim()) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
    } else {
      resetPassword();
    }
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
                      fontSize: 20),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
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
            SizedBox(height: 60),
            Center(
              child: Container(
                width: 370,
                child: TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Enter New Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  obscureText: true, // Hide the password input
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 370,
                child: TextFormField(
                  controller: reenterPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  obscureText: true, // Hide the password input
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty) // Display error message if any
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set the background color to orange
                minimumSize: const Size(200, 50), // Set the minimum width and height
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
