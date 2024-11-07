import 'package:flutter/material.dart';
import 'package:social_media_app/screens/login.dart';
import 'package:social_media_app/screens/util.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              OnboardingPage(
                imagePath: 'assets/images/onboarding1.png',
                title: 'Sharing your Idea',
                description:
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
              ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding2.png',
                title: 'Connect with Community',
                description:
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
              ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding3.png',
                title: 'Explore in Slidee App',
                description:
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
              ),
            ],
          ),
          Positioned(
            bottom: 120,
            left: 160,
            child: Container(
                height: 25,
                width: 70,
                decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage ? Colors.black : Colors.white70,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _currentPage < 2? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.43,
                  child: Button(
                    text: 'Skip', 
                    fontFamily: 'Regular',
                    fontSize: 18,
                    fontWeight: FontWeight.normal, 
                    onPressed: () {
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) => Login()));
                      }, 
                    backgroundColor: Colors.black, 
                    borderRadius: 30
                  )
                ),
                SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.43,
                  child: ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFF4979FF),
                    ),
                    child: Text(
                      _currentPage < 2 ? 'Next' : 'Get Started',
                      style: const TextStyle(color: Colors.white, fontFamily: 'Regular',fontSize: 18,fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            )
            : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToNextPage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Color(0xFF4979FF),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Regular',
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
               ),
          )
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height*.1),
        Container(
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 10),
        Container(
           child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Bold',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
        ),
      ],
    )
    );
  }
}
