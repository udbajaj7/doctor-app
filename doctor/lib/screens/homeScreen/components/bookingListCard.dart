import 'dart:convert';
import 'dart:core';
import 'package:doctor/Models/Appointment.dart';
import 'package:doctor/screens/addPatientScreen/AddPatientScreen.dart';
import 'package:doctor/components/urls.dart';
import 'package:doctor/screens/homeScreen/components/requests.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import '../../../components/size_config.dart';
import '../../../providers/appointmentProvider.dart';

class BookingListCard extends StatelessWidget {
  final PatientModel p;
  final DoctorBookingsModel d;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final Function refreshParent;
  BookingListCard(this.p, this.d, this.context, this.refreshIndicatorKey,
      this.scaffoldKey, this.refreshParent);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    TimeOfDay time = computeSlot(int.parse(d.slotTime));
    final AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: true);
    String name =
        (p.firstName + " " + p.lastName).characters.take(20).toString();
    if (name.length > (p.firstName + " " + p.lastName).length) name += "...";
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
          elevation: 0,
          margin: EdgeInsets.all(getProportionateScreenWidth(6)),
          child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Text(
                        d.slotNumber.toString(),
                        style: GoogleFonts.publicSans(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      radius: getProportionateScreenWidth(20.5),
                      backgroundColor: Colors.black.withOpacity(0.04),
                    ),
                    SizedBox(width: getProportionateScreenWidth(6)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.publicSans(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(6),
                            ),
                            myProfile.category.toLowerCase() == "dentist"
                                ? d.consentForm == false
                                    ? SizedBox(
                                        child: Image.asset(
                                            "assets/images/danger.png",
                                            color: Color(0xFF4D4D4D)),
                                        height: getProportionateScreenWidth(14),
                                        width: getProportionateScreenWidth(14),
                                      )
                                    : SizedBox(
                                        child: Image.asset(
                                            "assets/images/tick.png",
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
                          "${p.gender}, ${p.age}",
                          style: GoogleFonts.publicSans(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Treatment: ${d.treatment}",
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Time: ${time.format(context)}",
                                style: GoogleFonts.publicSans(
                                    fontSize: 12,
                                    color: Color(0xFF262B2F),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(12),
                                child: Center(
                                  child: PopupMenuButton(
                                    onSelected: (choice) {
                                      String message;
                                      String errorMesage =
                                          "Error while marking appointment as Cancelled!";
                                      String successMessage =
                                          "Patient's Appointment has been Cancelled!";
                                      if (choice == "Cancel") {
                                        message =
                                            "Are you sure you want to cancel the appointment";
                                      } else
                                        message =
                                            "Are you sure you want to reschedule the appointment";
                                      showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext _context) {
                                            return AlertDialog(
                                              title: Text(message),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    Navigator.of(_context)
                                                        .pop();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black)),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black)),
                                                  onPressed: () async {
                                                    scaffoldKey.currentContext!
                                                        .loaderOverlay
                                                        .show();
                                                    Navigator.of(_context)
                                                        .pop();
                                                    cancelAppointment(
                                                            d.bookingId)
                                                        .then((value) {
                                                      scaffoldKey
                                                          .currentContext!
                                                          .loaderOverlay
                                                          .hide();

                                                      if (value.contains(
                                                          "Success")) {
                                                        appointmentProvider
                                                            .cancelBookAppoin(
                                                                Appointment(
                                                                    doctorBookingsModel:
                                                                        d,
                                                                    patientModel:
                                                                        p));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    successMessage)));
                                                        if (choice ==
                                                            "Reschedule")
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddPatientScreen(
                                                              refreshIndicatorKey:
                                                                  refreshIndicatorKey,
                                                              firstName:
                                                                  p.firstName,
                                                              lastName:
                                                                  p.lastName,
                                                              age: p.age,
                                                              gender: p.gender,
                                                              phoneNumber:
                                                                  p.phoneNumber,
                                                              treatment:
                                                                  d.treatment,
                                                              getEarly: false,
                                                            ),
                                                          ));

                                                        refreshIndicatorKey
                                                            .currentState!
                                                            .show();
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    errorMesage)));
                                                      }
                                                      refreshIndicatorKey
                                                          .currentState!
                                                          .show();
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.menu,
                                      size: getProportionateScreenHeight(12),
                                      color: Color(0xFF43484D),
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Text("Cancel"),
                                        value: "Cancel",
                                      ),
                                      PopupMenuItem(
                                        child: Text("Reschedule"),
                                        value: "Reschedule",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          Skeleton.shade(
                              child: TextButton(
                                  onPressed: () async {
                                    return showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext _context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Mark Patient as Reached?'),
                                            actions: <Widget>[
                                              TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black)),
                                                  child: const Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    print(
                                                        "reached button is pressed");
                                                    Navigator.pop(_context);
                                                    scaffoldKey.currentContext!
                                                        .loaderOverlay
                                                        .show();
                                                    reachedButtonPressed(
                                                            myProfile.id,
                                                            d.bookingId)
                                                        .then((value) {
                                                      scaffoldKey
                                                          .currentContext!
                                                          .loaderOverlay
                                                          .hide();

                                                      if (!value
                                                          .contains("Error")) {
                                                        appointmentProvider
                                                            .patReached(Appointment(
                                                                doctorBookingsModel:
                                                                    d,
                                                                patientModel:
                                                                    p));
                                                      }

                                                      print(
                                                          "Calling refresh parent");
                                                      // refreshParent();
                                                      //  refreshIndicatorKey.currentState!.show();
                                                      print(
                                                          "Parent is refreshed");
                                                      // ScaffoldMessenger.of(context)
                                                      //     .showSnackBar(SnackBar(
                                                      //         content: Text(message)));
                                                    });
                                                  }),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: getProportionateScreenWidth(70),
                                    height: getProportionateScreenHeight(24),
                                    child: Center(
                                      child: Text("Reached",
                                          maxLines: 1,
                                          style: GoogleFonts.publicSans(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    minimumSize: Size(0, 0),
                                    side: BorderSide(
                                        width: 0.3, color: Colors.black),
                                  )))
                        ])
                  ]))),
    );
  }
}

Future<String> reachedButtonPressed(int docId, int bookingId) async {
  var response = await http.post(Uri.parse(reachedButtonUrl),
      body: jsonEncode(<String, int>{"doc_id": docId, "booking_id": bookingId}),
      headers: header);
  print("reached button status code ${response.statusCode}");
  if (response.statusCode == 200) {
    return "Okay";
  } else
    return "Error";
}
