import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testingme/Screens/registerDoneScreen.dart';
import 'package:http/http.dart'as http;

class SignUpScreens extends StatefulWidget {
  const SignUpScreens({super.key});

  @override
  State<SignUpScreens> createState() => _SignUpScreensState();
}

class _SignUpScreensState extends State<SignUpScreens> {



  void submitForm() async {
    final url = Uri.parse('https://assignment-61518-default-rtdb.firebaseio.com/userdata.json');

    final formData = {
      "full_name": fullnameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text.trim(),
      "role": "farmer", // You can change this as needed
      "business_name": businessNameController.text.trim(),
      "informal_name": informalNameController.text.trim(),
      "address": streetAddressController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "zip_code": zipcodeController.text.trim(),
      "registration_proof": "my_proof.pdf", // Update this with actual file handling logic
      "business_hours": businessHours
    };

    print('Submitting the following data:');
    print(jsonEncode(formData));

    try {
      final response = await http.post(url, body: jsonEncode(formData));

      if (response.statusCode == 200) {
        print('Form submitted successfully!');
        // Navigate to the next screen or show success message
      } else {
        print('Failed to submit form. Status code: ${response.statusCode}');
        // Handle failure
      }
    } catch (error) {
      print('Error submitting form: $error');
      // Handle error
    }
  }




  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final reenterPasswordController = TextEditingController();

  final businessNameController = TextEditingController();
  final informalNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();

  final PageController pageController = PageController();

  Map<String, List<String>> businessHours = {
    'M': [],
    'T': [],
    'W': [],
    'Th': [],
    'F': [],
    'S': [],
    'Su': [],
  };

  Set<String> selectedDays = {};
  String? selectedDay; // To track the currently selected day

  void nextPage() {
    pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void previousPage() {
    pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool validateInputs() {
    String fullname = fullnameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String reenteredPassword = reenterPasswordController.text.trim();

    if (fullname.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        reenteredPassword.isEmpty) {
      showError('All fields must be filled.');
      return false;
    }

    if (password != reenteredPassword) {
      showError('Passwords do not match.');
      return false;
    }

    return true;
  }

  Widget buildDayButton(String day) {
    bool isSelected = selectedDays.contains(day);
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedDays.remove(day);
              businessHours[day]?.clear(); // Clear times if day is deselected
              print('Deselected day: $day');
              print('Business hours after deselecting: $businessHours');
              selectedDay = null; // Reset selected day
            } else {
              selectedDays.add(day);
              selectedDay = day; // Set selected day
              print('Selected day: $day');
              print('Business hours after selecting: $businessHours');
            }
          });
        },
        child: Text(day),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFFE57373) : Colors.grey,
          padding: EdgeInsets.zero,
          textStyle: TextStyle(fontSize: 12),
          shape: CircleBorder(),
        ),
      ),
    );
  }

  Widget buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildDayButton('M'),
        buildDayButton('T'),
        buildDayButton('W'),
        buildDayButton('Th'),
        buildDayButton('F'),
        buildDayButton('S'),
        buildDayButton('Su'),
      ],
    );
  }

  Widget buildTimeSelector(String time) {
    bool isTimeSelected = selectedDay != null &&
        (businessHours[selectedDay]?.contains(time) ?? false);


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (isTimeSelected) {
              businessHours[selectedDay]?.remove(time);
              print('Removed time: $time for day: $selectedDay');
            } else {
              businessHours[selectedDay]?.add(time);
              print('Added time: $time for day: $selectedDay');
            }
            print('Business hours after updating: $businessHours');
          });
        },
        child: Text(time),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isTimeSelected ? Color(0xFFE57373) : Colors.grey[200],
          minimumSize: Size(double.infinity, 40),
        ),
      ),
    );
  }

  void printBusinessHours() {
    print('Selected Business Hours:');
    selectedDays.forEach((day) {
      print('$day: ${businessHours[day]}');
    });
  }


  Future<void> sendUserData(Map<String, dynamic> userData) async {
    final String url = 'https://assignment-61518-default-rtdb.firebaseio.com/user_data.json';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        print('Data saved successfully.');
      } else {
        print('Failed to save data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildWelcomeScreen(),
            buildFarmInfoScreen(),
            buildVerificationScreen(),
            buildBusinessHoursScreen(),
            buildNewVerificationScreen(),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeScreen() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Welcome',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildTextField('Fullname', controller: fullnameController),
          buildTextField('Email Address', controller: emailController),
          buildTextField('Phone Number', controller: phoneController),
          buildTextField('Password',
              obscureText: true, controller: passwordController),
          buildTextField('Re-enter Password',
              obscureText: true, controller: reenterPasswordController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: nextPage,
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE57373),
              minimumSize: Size(double.infinity, 50),
            ),
          ),
          TextButton(
            onPressed: () {}, // Add login functionality here
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget buildFarmInfoScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Farm Info',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildTextField('Business Name', controller: businessNameController),
          buildTextField('Informal Name', controller: informalNameController),
          buildTextField('Street Address', controller: streetAddressController),
          buildTextField('City', controller: cityController),
          Row(
            children: [
              Expanded(
                  child: buildTextField('State', controller: stateController)),
              SizedBox(width: 10),
              Expanded(
                  child:
                  buildTextField('Zipcode', controller: zipcodeController)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
              ElevatedButton(
                onPressed: nextPage,
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE57373),
                  minimumSize: Size(100, 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildVerificationScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verification',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Attach proof of Department of Agriculture registration (e.g. Florida Fresh, USDA Approved, USDA Organic).',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {}, // Add file attachment functionality here
            icon: Icon(Icons.camera_alt),
            label: Text('Attach proof of registration'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              minimumSize: Size(double.infinity, 50),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
              ElevatedButton(
                onPressed: nextPage,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE57373),
                  minimumSize: Size(100, 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNewVerificationScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verification',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Attach proof of Department of Agriculture registration (e.g. Florida Fresh, USDA Approved, USDA Organic).',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {}, // Add file attachment functionality here
            icon: Icon(Icons.camera_alt),
            label: Text('Attach proof of registration'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              minimumSize: Size(double.infinity, 50),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
              ElevatedButton(
                onPressed: (){submitForm();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Done()));
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE57373),
                  minimumSize: Size(100, 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBusinessHoursScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Hours',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Select Days:'),
          buildDaySelector(),
          SizedBox(height: 20),
          if (selectedDay != null) ...[
            Text('Select Hours for $selectedDay:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildTimeSelector('12:00pm - 2:00pm')),
                SizedBox(width: 10),
                Expanded(child: buildTimeSelector('2:00pm - 4:00pm')),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildTimeSelector('4:00pm - 6:00pm')),
                SizedBox(width: 10),
                Expanded(child: buildTimeSelector('6:00pm - 8:00pm')),
              ],
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedDays.isNotEmpty) {
                printBusinessHours(); // Print business hours when continuing
                nextPage(); // Only go to the next page if at least one day is selected
              }
            },
            child: Text('Continue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE57373),
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label,
      {TextEditingController? controller, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
