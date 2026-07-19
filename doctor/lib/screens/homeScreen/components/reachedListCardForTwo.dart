import 'package:doctor/Models/Appointment.dart';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import 'requests.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ReachedListCardForTwo extends StatefulWidget {
  final PatientModel p;
  final DoctorBookingsModel d;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final Function notifyParent;
  final int minutes;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Appointment r1;
  final Appointment r2;
  ReachedListCardForTwo(this.p, this.d, this.refreshIndicatorKey, this.minutes,
      this.r1, this.r2, this.scaffoldKey, this.notifyParent);

  @override
  State<ReachedListCardForTwo> createState() => _ReachedListCardForTwoState();
}

class _ReachedListCardForTwoState extends State<ReachedListCardForTwo> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    int _minutes = widget.minutes;
    int hours = 0;
    if (_minutes > 59) {
      hours = (_minutes / 60).floor();
      _minutes -= (hours * 60);
    }
    bool useOne = true;
    String name = (widget.p.firstName + " " + widget.p.lastName)
        .characters
        .take(20)
        .toString();
    if (name.length > (widget.p.firstName + " " + widget.p.lastName).length)
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
        margin: EdgeInsets.all(getProportionateScreenWidth(6)),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text(
                  widget.d.slotNumber.toString(),
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
                          ? widget.d.consentForm == false
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
                    "${widget.p.gender}, ${widget.p.age}",
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Treatment: ${widget.d.treatment}",
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
                    "Time Left: ${widget.minutes}" + " mins",
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: Color(0xFF262B2F),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: getProportionateScreenHeight(6)),
                  Skeleton.shade(
                    child: TextButton(
                        onPressed: () {
                          if (widget.r2.patientModel.firstName != "") {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Room Filled!',
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      12)),
                                          Text(
                                            ' Please select one of the patients below to remove',
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CheckboxListTile(
                                            title: Text(
                                              widget.r1.patientModel.firstName,
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              widget.r1.patientModel.gender +
                                                  ", " +
                                                  widget.r1.patientModel.age
                                                      .toString(),
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: useOne,
                                            value: useOne,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                useOne = value!;
                                              });
                                            },
                                          ),
                                          CheckboxListTile(
                                            title: Text(
                                              widget.r2.patientModel.firstName,
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              widget.r2.patientModel.gender +
                                                  ", " +
                                                  widget.r2.patientModel.age
                                                      .toString(),
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: !useOne,
                                            value: !useOne,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                useOne = !value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 243, 243, 243)),
                                          child: Text('Cancel',
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.black)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.black),
                                          child: Text('Ok',
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            if (useOne) {
                                              widget.scaffoldKey.currentContext!
                                                  .loaderOverlay
                                                  .show();
                                              sendInButtonPressed(
                                                      myProfile.id,
                                                      widget.d.bookingId,
                                                      widget
                                                          .r1
                                                          .doctorBookingsModel
                                                          .bookingId)
                                                  .then((value) {
                                                widget
                                                    .scaffoldKey
                                                    .currentContext!
                                                    .loaderOverlay
                                                    .hide();
                                                String message = "";
                                                Navigator.of(context).pop();
                                                if (value.contains("Done")) {
                                                  message =
                                                      "Patient has been marked as Sent In!";
                                                }
                                                if (value.contains("Error"))
                                                  message =
                                                      "Error while marking patient as Sent In!";
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(message)));
                                                widget.notifyParent();
                                                widget.refreshIndicatorKey
                                                    .currentState!;
                                              });
                                            } else {
                                              widget.scaffoldKey.currentContext!
                                                  .loaderOverlay
                                                  .show();
                                              sendInButtonPressed(
                                                      myProfile.id,
                                                      widget.d.bookingId,
                                                      widget
                                                          .r2
                                                          .doctorBookingsModel
                                                          .bookingId)
                                                  .then((value) {
                                                widget
                                                    .scaffoldKey
                                                    .currentContext!
                                                    .loaderOverlay
                                                    .hide();
                                                Navigator.of(
                                                        context) // issue can be here
                                                    .pop();
                                                String message = "";
                                                if (value.contains("Done"))
                                                  message =
                                                      "Patient has been marked as Sent In!";
                                                if (value.contains("Error"))
                                                  message =
                                                      "Error while marking patient as Sent In!";
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(message)));
                                                widget.notifyParent();
                                                widget.refreshIndicatorKey
                                                    .currentState!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } else if (widget.r1.patientModel.firstName != "") {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext _context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      12)),
                                          Text(
                                            ' Please select one of the patients below to remove',
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CheckboxListTile(
                                            title: Text(
                                              widget.r1.patientModel.firstName,
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              widget.r1.patientModel.gender +
                                                  ", " +
                                                  widget.r1.patientModel.age
                                                      .toString(),
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: useOne,
                                            value: useOne,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                useOne = value!;
                                              });
                                            },
                                          ),
                                          CheckboxListTile(
                                            title: Text(
                                              "Add Patient",
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: !useOne,
                                            value: !useOne,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                useOne = !value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 243, 243, 243)),
                                          child: Text('Cancel',
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.black)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.black),
                                          child: Text('Confirm',
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            if (useOne) {
                                              widget.scaffoldKey.currentContext!
                                                  .loaderOverlay
                                                  .show();
                                              sendInButtonPressed(
                                                      myProfile.id,
                                                      widget.d.bookingId,
                                                      widget
                                                          .r1
                                                          .doctorBookingsModel
                                                          .bookingId)
                                                  .then((value) {
                                                widget
                                                    .scaffoldKey
                                                    .currentContext!
                                                    .loaderOverlay
                                                    .hide();
                                                Navigator.of(context).pop();
                                                String message = "";
                                                if (value.contains("Done"))
                                                  message =
                                                      "Patient has been marked as Sent In!";
                                                if (value.contains("Error"))
                                                  message =
                                                      "Error while marking patient as Sent In!";
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(message)));
                                                widget.notifyParent();
                                                widget.refreshIndicatorKey
                                                    .currentState!;
                                              });
                                            } else {
                                              widget.scaffoldKey.currentContext!
                                                  .loaderOverlay
                                                  .show();
                                              sendInButtonPressed(myProfile.id,
                                                      widget.d.bookingId, null)
                                                  .then((value) {
                                                widget
                                                    .scaffoldKey
                                                    .currentContext!
                                                    .loaderOverlay
                                                    .hide();
                                                Navigator.of(_context).pop();
                                                String message = "";
                                                if (value.contains("Done"))
                                                  message =
                                                      "Patient has been marked as Sent In!";
                                                if (value.contains("Error"))
                                                  message =
                                                      "Error while marking patient as Sent In!";
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(message)));
                                                widget.notifyParent();
                                                widget.refreshIndicatorKey
                                                    .currentState!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } else if (widget.r1.patientModel.firstName == "" &&
                              widget.r2.patientModel.firstName == "") {
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
                                        child: Text("Cancel"),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black)),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black)),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          widget.scaffoldKey.currentContext!
                                              .loaderOverlay
                                              .show();
                                          sendInButtonPressed(myProfile.id,
                                                  widget.d.bookingId, null)
                                              .then((value) {
                                            widget.scaffoldKey.currentContext!
                                                .loaderOverlay
                                                .hide();
                                            if (value.contains("Done")) {
                                              Navigator.of(_context).pop();
                                              String message =
                                                  "Patient has been marked as Sent In!";
                                              if (value.contains("Error"))
                                                message =
                                                    "Error while marking patient as Sent In!";
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(message)));
                                              widget.notifyParent();
                                              widget.refreshIndicatorKey
                                                  .currentState!;
                                            } else {
                                              return Center(
                                                child: SpinKitPouringHourGlass(
                                                    color: Colors.grey),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
