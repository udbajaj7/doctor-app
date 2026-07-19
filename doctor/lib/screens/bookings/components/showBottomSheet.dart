import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Widget bottomSheet(BuildContext context, String name, int age,
    String phoneNumber, String gender,String treatment) {
  return AlertDialog(
      title: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: FittedBox(
                child: Text("Patient Details",
                    style: GoogleFonts.publicSans(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextButton(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Contact",
                      style: GoogleFonts.publicSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                color: Colors.black,
                height: 60,
                width: double.infinity,
              ),
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                await launchUrl(launchUri);
              }),
        ),
      ],
      content: ClipRRect(
          borderRadius: BorderRadius.circular(35.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 1, thickness: 1, color: Colors.white),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.014,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Name:",
                              style: GoogleFonts.publicSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                          Text(name,
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Age:",
                              style: GoogleFonts.publicSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                          Text(age.toString(),
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gender:",
                              style: GoogleFonts.publicSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                          Text(gender,
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Mobile:",
                              style: GoogleFonts.publicSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                          Text(phoneNumber.toString(),
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      
                      SizedBox(height: 20),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Treatment:",
                              style: GoogleFonts.publicSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                          Text(treatment,
                              style: GoogleFonts.publicSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                        SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          )));
}
