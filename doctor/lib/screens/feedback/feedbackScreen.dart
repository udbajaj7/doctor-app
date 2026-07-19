import 'package:doctor/screens/homeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

import '../../components/standard_app_bar.dart';
import '../../components/urls.dart';
import '../loginScreen/components/button_container.dart';
import '../otp/components/error_dialog.dart';
import 'components/request.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int currIndex = 4;
  String comment = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: standardAppBar(context, "Feedback"),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: submitFeedback(
                              myProfile.id, currIndex + 1, comment),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.toString().contains("Error")) {
                                return ErrorDialog(
                                    context, snapshot.data.toString(), false);
                              } else {
                                return HomeScreen();
                              }
                            } else
                              return Center(
                                child:
                                    SpinKitPouringHourGlass(color: Colors.grey),
                              );
                          },
                        ),
                      ),
                      (route) => false);
                },
                child: buttonContainer(context, "Submit")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            RichText(
              text: TextSpan(
                text: 'How do you feel about ',
                style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                      text: 'INCUE?',
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 18))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: EmojiFeedback(
                
                onChanged: (index) {                  
                  setState(() {
                    currIndex = index;
                  });
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "What did you like or dislike about \nyour experience?",
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ]),
              child: TextField(
                onChanged: (value) => comment = value,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: "Describe briefly...",
                    hintStyle: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w400, fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}
