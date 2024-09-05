import 'package:flutter/material.dart';

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Image.asset('images/ticck.png'), // Load the image from assets
            const SizedBox(height: 30), // Add some space below the image
            const Text(
              'Youre all done !', // Add a text message below the image
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text(
                'Hang tight! We are currently reviewing your account and will foolow up with you in 2-3 business days.In the meantime you can setup your inventory',textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(200,50)
                ),
                child: Text('Got it'))
          ],
        ),
      ),
    );
  }
}
