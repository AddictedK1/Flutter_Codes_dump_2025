import 'package:flutter/material.dart';
import '../widgets/intro_page_widget.dart';
import '../services/shared_prefs.dart';
import 'dashboard_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  List<Map<String, String>> introData = [
    {"title": "Welcome", "desc": "Welcome to this awesome intro screen app.", "img": "assets/images/intro1.png"},
    {"title": "Read Anywhere", "desc": "Read books anytime, anywhere.", "img": "assets/images/intro2.png"},
    {"title": "Get Started", "desc": "Dive into your favorite books now.", "img": "assets/images/intro3.png"},
  ];

  void _finishIntro() async {
    await SharedPrefs.setFirstLaunchFalse();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemCount: introData.length,
        itemBuilder: (_, i) {
          return IntroPageWidget(
            title: introData[i]["title"]!,
            description: introData[i]["desc"]!,
            imagePath: introData[i]["img"]!,
          );
        },
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _finishIntro,
              child: Text("Skip"),
            ),
            Row(
              children: List.generate(
                introData.length,
                (index) => Container(
                  margin: EdgeInsets.all(4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? Colors.red : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            TextButton(
              child: Text(currentIndex == introData.length - 1 ? "Done" : "Next"),
              onPressed: () {
                if (currentIndex == introData.length - 1) {
                  _finishIntro();
                } else {
                  _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
