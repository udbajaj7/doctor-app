import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName) {
    return Image.asset(
      'assets/$assetName',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
        bodyTextStyle: GoogleFonts.publicSans(fontSize: 32),
        bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: const Color.fromARGB(255, 232, 244, 255),
        imagePadding: EdgeInsets.zero,
        footerPadding: const EdgeInsets.only(top: 130));

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: const Color.fromARGB(255, 232, 244, 255),
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Book", style: GoogleFonts.publicSans(fontSize: 32)),
              Text("Appointments with",
                  style: GoogleFonts.publicSans(fontSize: 32)),
              Text("Doctors", style: GoogleFonts.publicSans(fontSize: 32)),
            ],
          ),
          image: _buildImage('images/image1.png'),
          decoration: pageDecoration,
          footer: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 244, 255),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.85, 64),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                introKey.currentState!.controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                "NEXT",
                style:
                    GoogleFonts.publicSans(fontSize: 27, color: Colors.black),
              )),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Get Estimated Time",
                    style: GoogleFonts.publicSans(fontSize: 32)),
                Text("of Appointment",
                    style: GoogleFonts.publicSans(fontSize: 32))
              ],
            ),
          ),
          image: _buildImage('images/image2.png'),
          decoration: pageDecoration,
          footer: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 244, 255),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.85, 64),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                introKey.currentState!.controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                "NEXT",
                style:
                    GoogleFonts.publicSans(fontSize: 27, color: Colors.black),
              )),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Keep track of your",
                    style: GoogleFonts.publicSans(fontSize: 32)),
                Text("Position in the Queue",
                    style: GoogleFonts.publicSans(fontSize: 32))
              ],
            ),
          ),
          image: _buildImage('images/image3.png'),
          decoration: pageDecoration,
          footer: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 244, 255),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.85, 64),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                introKey.currentState!.controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                "NEXT",
                style:
                    GoogleFonts.publicSans(fontSize: 27, color: Colors.black),
              )),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Get Live Updates",
                    style: GoogleFonts.publicSans(fontSize: 32))
              ],
            ),
          ),
          image: _buildImage('images/image4.png'),
          decoration: pageDecoration,
          footer: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.85, 64),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                Navigator.pushNamed(context, "logIn");
              },
              child: Text(
                "GET STARTED",
                style:
                    GoogleFonts.publicSans(fontSize: 27, color: Colors.white),
              )),
        ),
      ],
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: InkWell(
          onTap: () {
            introKey.currentState!.controller.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          child: CircleAvatar(
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            radius: 24,
            backgroundColor: Colors.black,
          )),
      showDoneButton: false,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.transparent,
        activeColor: Colors.black,
        shape: CircleBorder(side: BorderSide(color: Colors.black)),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Color.fromARGB(255, 232, 244, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      isProgress: true,
      isProgressTap: true,
      showNextButton: false,
//       globalHeader: AnimatedSmoothIndicator(
//    activeIndex: introKey.currentState!.controller.page.toInt(),
//    count:  6,
//    effect:  WormEffect(),
// ),
      dotsFlex: 100,
    );
  }
}
