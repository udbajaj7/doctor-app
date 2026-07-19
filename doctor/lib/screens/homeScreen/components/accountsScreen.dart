import 'dart:ui';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/MultipleProfileScreen/MultipleProfileScreen.dart';
import 'package:doctor/screens/allPatientScreen/allPatientScreen.dart';
import 'package:doctor/screens/bookings/bookingsHistoryScreens.dart';
import 'package:doctor/screens/homeScreen/homeScreen.dart';
import 'package:doctor/screens/loginScreen/SignUpScreen.dart';
import 'package:doctor/screens/loginScreen/loginScreen.dart';
import 'package:doctor/screens/reschedule.dart/reshedule.dart';
import 'package:doctor/components/urls.dart';
import 'package:doctor/screens/review%20Screen/ReviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../editProfile/editProfileScreen.dart';
import '../../feedback/feedbackScreen.dart';
import '../../leaves/components/body.dart';

class AccountsScreen extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  AccountsScreen({required this.refreshIndicatorKey});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  bool popNotReload = true;
  @override
  Widget build(BuildContext context) {
    String idsString = prefs.getString("DocIds") ?? "";

    var ids = idsString.split(',');
    if (ids[ids.length - 1].isEmpty)
      ids.removeAt(ids.length - 1); // removing the last empty value

    print("ids are $ids");
    String namesString = prefs.getString("DocNames") ?? "";

    print("doctor names are : $namesString");
    var names = namesString.split(',');
    if (names[names.length - 1].isEmpty) names.removeAt(names.length - 1);
    print("names are $names");
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          "Account",
          style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w700, color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Transform.translate(
          offset: Offset(14, 0),
          child: InkWell(
            onTap: () {
              if (popNotReload && ids.length <= 1)
                Navigator.pop(context);
              else
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
            },
            child: Container(
              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(getProportionateScreenWidth(100)),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Icon(
                Icons.chevron_left_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
          child: Column(
            children: [
              ids.length <= 1 ? Container() : MultipleProfileScreen(),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ]),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenWidth(8))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Image.asset("assets/images/doctor_image.jpg",
                              fit: BoxFit.fill),
                          radius: getProportionateScreenWidth(36.5),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myProfile.firstName + " " + myProfile.lastName,
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              myProfile.degrees,
                              style: GoogleFonts.publicSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6B6B6B)),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        MaterialButton(
                          shape: CircleBorder(),
                          elevation: 0,
                          color: Colors.black.withOpacity(0.04),
                          padding: const EdgeInsets.all(14),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                        myProfile.phoneNumber)));
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ]),
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingsHistoryScreen(
                                        refreshIndicatorKey:
                                            widget.refreshIndicatorKey,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Bookings",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeaveScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Leaves",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Patient Reviews",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Reschedule()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Rescheduled Clinic Timings",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ]),
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text("Do you want to add another account ?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("No"))
                              ],
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Add Profiles",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Feedback",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      //    Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => FeedbackScreen()));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(22),
                      //         child: Text(
                      //           "Delete Account",
                      //           style: GoogleFonts.publicSans(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: Colors.black),
                      //         ),
                      //       ),
                      //       Text("")
                      //     ],
                      //   ),
                      // ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          popNotReload = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllPatientScreen()));
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Text(
                              "All Patients",
                              style: GoogleFonts.publicSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: AlertDialog(
                                  title: Text(
                                    'Contact Details',
                                    style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                          'Call Us',
                                          style: GoogleFonts.publicSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            makePhoneCall("9019368875");
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    width: 0,
                                                    color: Colors.black)),
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Mail Us',
                                          style: GoogleFonts.publicSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            email();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    width: 0,
                                                    color: Colors.black)),
                                            child: Icon(
                                              Icons.email_sharp,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Contact Us",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                      InkWell(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: AlertDialog(
                                  title: RichText(
                                    text: TextSpan(
                                      text: 'Log out of ',
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'INCUE?',
                                            style: GoogleFonts.josefinSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      child: Text('Log Out',
                                          style: GoogleFonts.publicSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.white)),
                                      onPressed: () async {
                                        clearData();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpScreen()),
                                            (route) => false);
                                      },
                                    ),
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      child: Text('Cancel',
                                          style: GoogleFonts.publicSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.black)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Text(
                                "Log Out",
                                style: GoogleFonts.publicSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: getProportionateScreenWidth(35),
                        child: Image.asset(
                          "assets/images/logo_without_title.png",
                          fit: BoxFit.contain,
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '2022 ',
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'INCUE',
                                style: GoogleFonts.josefinSans(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 12)),
                            TextSpan(
                                text: '. All rights reserved',
                                style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void clearData() {
  metaData.isLoggedIn = false;
  myProfile.id = -1;
  prefs.clear();
}

Future<void> email() async {
  final mailtoLink =
      Mailto(to: ['incue.co.in@gmail.com'], subject: 'INCUE App Feedback');
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launchUrl(Uri.parse(mailtoLink.toString()));
}

Future<void> makePhoneCall(String phoneNumber) async {
  await FlutterPhoneDirectCaller.callNumber(phoneNumber);
}
