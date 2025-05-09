import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/main_navigation.dart';
import '../auth/register_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/on1.jpg",
      "title": "Make Yourself Stronger",
      "subtitle": "Smash your goals with\nworkouts tailored just for you",
    },
    {
      "image": "assets/on2.png",
      "title": "5 Premium Courses",
      "subtitle": "Train with the best\nfitness coaches worldwide",
    },
    {
      "image": "assets/on3.png",
      "title": "Welcome Back!",
      "subtitle": "Stay motivated and\ntrack your progress daily",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // المستخدم مسجل دخول بالفعل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    }
  }

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen()),
      );
    }
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: _currentIndex == index ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.black : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(
                onboardingData.length,
                (index) => _buildDot(index),
              ),
            ),
            GestureDetector(
              onTap: _nextPage,
              child: Text(
                _currentIndex == onboardingData.length - 1 ? "Start" : "Next",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                data["image"]!,
                width: double.infinity,
                height: 480,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  data["title"]!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  data["subtitle"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
