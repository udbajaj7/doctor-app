import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import '../../../components/size_config.dart';
import '../../addPatientScreen/AddPatientScreen.dart';
import 'requests.dart';

class ReachedListCard extends StatelessWidget {
  final int bookingID;
  final PatientModel patientModel;
  final DoctorBookingsModel doctorBookingsModel;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function notifyParent;
  final int minutes;

  ReachedListCard(
      this.patientModel,
      this.doctorBookingsModel,
      this.refreshIndicatorKey,
      this.minutes,
      this.bookingID,
      this.scaffoldKey,
      this.notifyParent);

  @override
  Widget build(BuildContext context) {
    int _minutes = minutes;
    TimeOfDay time = computeSlot(int.parse(doctorBookingsModel.slotTime));
    int hours = 0;
    if (_minutes > 59) {
      hours = (_minutes / 60).floor();
      _minutes -= (hours * 60);
    }
    String name = (patientModel.firstName + " " + patientModel.lastName)
        .characters
        .take(20)
        .toString();
    if (name.length >
        (patientModel.firstName + " " + patientModel.lastName).length)
      name += "...";
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 5,
          offset: Offset(0, 0),
        ),
      ]),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(getProportionateScreenWidth(6)),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text(
                  doctorBookingsModel.slotNumber.toString(),
                  style: GoogleFonts.publicSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                radius: getProportionateScreenWidth(20.5),
                backgroundColor: Colors.black.withOpacity(0.04),
              ),
              SizedBox(width: getProportionateScreenWidth(4)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        maxLines: 4,
                        style: GoogleFonts.publicSans(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(6),
                      ),
                      myProfile.category.toLowerCase() == "dentist"
                          ? doctorBookingsModel.consentForm == false
                              ? SizedBox(
                                  child: Image.asset("assets/images/danger.png",
                                      color: Color(0xFF4D4D4D)),
                                  height: getProportionateScreenWidth(14),
                                  width: getProportionateScreenWidth(14),
                                )
                              : SizedBox(
                                  child: Image.asset("assets/images/tick.png",
                                      color: Color(0xFF4D4D4D)),
                                  height: getProportionateScreenWidth(14),
                                  width: getProportionateScreenWidth(14),
                                )
                          : SizedBox(height: 0),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(4),
                  ),
                  Text(
                    "${patientModel.gender}, ${patientModel.age}",
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Treatment: ${doctorBookingsModel.treatment}",
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: Color(0xFF262B2F),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        "Time Left: $minutes" + " mins",
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: Color(0xFF262B2F),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: getProportionateScreenHeight(6)),
                  Skeleton.shade(
                    child: TextButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext _context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Are you sure you want to Send In?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(_context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black)),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black)),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(_context).pop();
                                        scaffoldKey
                                            .currentContext!.loaderOverlay
                                            .show();
                                        sendInButtonPressed(
                                                myProfile.id,
                                                doctorBookingsModel.bookingId,
                                                bookingID)
                                            .then((value) {
                                          scaffoldKey
                                              .currentContext!.loaderOverlay
                                              .hide();
                                          String message;
                                          if (value.contains("Done")) {
                                            debugPrint("sendInButtonCLicked");

                                            message =
                                                "Patient has been marked as Sent In!";

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(message)));
                                            notifyParent();
                                          } else if (value.contains("Error")) {
                                            message =
                                                "Error while marking patient as Sent In!";
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(message)));
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          width: getProportionateScreenWidth(70),
                          height: getProportionateScreenHeight(24),
                          child: Center(
                            child: Text("Send In",
                                style: GoogleFonts.publicSans(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(0, 0),
                          side: BorderSide(width: 0.3, color: Colors.black),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
