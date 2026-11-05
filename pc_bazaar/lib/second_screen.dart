import 'package:flutter/material.dart';
import 'login_page.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Content for the 3 slides
  final List<Map<String, String>> pages = [
    {
      "title": "Safe Deals",
      "subtitle": "Your transactions are secure and protected.",
      "image": "assets/img1.jpg",
    },
    {
      "title": "AI Assistant",
      "subtitle": "Get smart guidance with our built-in AI assistant.",
      "image": "assets/img2.jpg",
    },
    {
      "title": "Escrow Payments",
      "subtitle": "Payments are held safely until the deal is complete.",
      "image": "assets/img3.jpg",
    },
  ];

  void _nextPage() {
  if (_currentPage < pages.length - 1) {
    _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  } else {
    // Navigate to Login Page after Finish
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Slider (PageView)
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        pages[index]["image"]!,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 30),
                      Text(
                        pages[index]["title"]!,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        pages[index]["subtitle"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _nextPage,
              child: Text(
                _currentPage == pages.length - 1 ? "Finish" : "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
