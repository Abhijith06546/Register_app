import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:testingme/Screens/loginscreen.dart';
import 'package:testingme/Screens/registerScreens.dart';
import 'package:testingme/models/onboardingItems.dart';

class onboardingScreen extends StatefulWidget {
  const onboardingScreen({super.key});

  @override
  State<onboardingScreen> createState() => _onboardingScreenState();
}

class _onboardingScreenState extends State<onboardingScreen> {
  final controller = PageController();
  final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Quality',
      description:
          'Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain.',
      color: Color.fromARGB(255, 205, 236, 255),
      imagePath: 'images/assignment1.jpg', // Update with correct image paths
    ),
    OnboardingItem(
      title: 'Convenient',
      description:
          'Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.',
      color: Color.fromARGB(255, 113, 195, 232),
      imagePath: 'images/assignment2.jpg', // Update with correct image paths
    ),
    OnboardingItem(
      title: 'Local',
      description:
          'We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time.',
      color: Color.fromARGB(255, 255, 218, 169),
      imagePath: 'images/assignment3.png', // Update with correct image paths
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            PageView.builder(
                controller: controller,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return buildItem(items[index]);
                })
          ],
        ),
    );
  }

  Widget buildItem(OnboardingItem item) {
    return Container(
      color: item.color,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                ),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(62)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: items.length,
                        effect: WormEffect(
                            dotColor: Colors.grey, activeDotColor: item.color),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreens()),
                            );
                          },
                          child: Text(
                            'Join the movement',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
