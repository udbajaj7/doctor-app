import 'package:doctor/Models/Appointment.dart';
import 'package:doctor/screens/homeScreen/components/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import '../../../components/size_config.dart';
import '../../../components/urls.dart';
import '../../../providers/appointmentProvider.dart';
import 'ChangeTreatmentDialogBox.dart';
import 'duesScreen.dart';

class CurrentPatientForTwo extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final DoctorBookingsModel doctorBookingsModel;
  final PatientModel patientModel;
  final List<DoctorBookingsModel> bookListReached;
  final List<PatientModel> patListReached;
  final int index;
  final GlobalKey<ScaffoldState> scaffoldKey;
  CurrentPatientForTwo(
      this.doctorBookingsModel,
      this.patientModel,
      this.bookListReached,
      this.patListReached,
      this.refreshIndicatorKey,
      this.index,
      this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    String name = (patientModel.firstName + " " + patientModel.lastName)
        .characters
        .take(20)
        .toString();
    if (name.length >
        (patientModel.firstName + " " + patientModel.lastName).length)
      name += "...";

    final AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: true);
    SizeConfig().init(context);
    return Expanded(
      child: Container(
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
          color: Color.fromARGB(255, 42, 42, 42),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 4,
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(6),
                        ),
                        myProfile.category.toLowerCase() == "dentist"
                            ? doctorBookingsModel.consentForm == false
                                ? SizedBox(
                                    child: Image.asset(
                                        "assets/images/danger.png",
                                        color: Color(0xFFD4D4D4)),
                                    height: getProportionateScreenWidth(14),
                                    width: getProportionateScreenWidth(14),
                                  )
                                : SizedBox(
                                    child: Image.asset("assets/images/tick.png",
                                        color: Color(0xFFD4D4D4)),
                                    height: getProportionateScreenWidth(14),
                                    width: getProportionateScreenWidth(14),
                                  )
                            : SizedBox(height: 0),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DuesScreen(
                                      refreshIndicatorKey: refreshIndicatorKey,
                                      notes: doctorBookingsModel.notes,
                                      bookingId: doctorBookingsModel.bookingId,
                                      balance: doctorBookingsModel.balance,
                                      fName: patientModel.firstName,
                                      lName: patientModel.lastName,
                                      age: patientModel.age,
                                      gender: patientModel.gender,
                                      phoneNumber: patientModel.phoneNumber,
                                      treatment: doctorBookingsModel.treatment,
                                      installment:
                                          doctorBookingsModel.installment);
                                },
                              );
                            },
                            icon: SvgPicture.asset(
                              "assets/images/clarity_settings-solid.svg",
                              height: getProportionateScreenHeight(12),
                              width: getProportionateScreenWidth(12),
                            )),
                      ],
                    ),
                    Text(
                      "${patientModel.gender}, ${patientModel.age}",
                      style: GoogleFonts.publicSans(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Row(
                      children: [
                        Text(
                          doctorBookingsModel.treatment,
                          style: GoogleFonts.publicSans(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(4),
                        ),
                        InkWell(
                          onTap: () async {
                            var treatment = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return ChangeTreatmentDialogBox(
                                    doctorBookingsModel.treatment);
                              },
                            );
                            context.loaderOverlay.show();
                            if (treatment == "" || treatment == null) {
                              context.loaderOverlay.hide();
                              return;
                            }
                            await editTreatmentApi(
                                    doctorBookingsModel.bookingId, treatment)
                                .then((value) {
                              context.loaderOverlay.hide();
                              var message = "";
                              if (value == "Done") {
                                message = "Treatment updated successfully";
                              } else
                                message =
                                    "Could not update treatment due to some error";
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)));
                              refreshIndicatorKey.currentState!.show();
                            });
                          },
                          child: Container(
                            height: getProportionateScreenHeight(20),
                            width: getProportionateScreenWidth(32),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.edit,
                                size: getProportionateScreenHeight(10),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Current Patient",
                      style: GoogleFonts.publicSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                    margin:
                        EdgeInsets.only(right: getProportionateScreenWidth(8)),
                      child: CircleAvatar(
                        child: Text(
                          doctorBookingsModel.slotNumber.toString(),
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        radius: getProportionateScreenWidth(20.5),
                        backgroundColor: Colors.white.withOpacity(0.04),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
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
                                        child: Text("Cancel",
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                          bookListReached.length > 0
                                              ? sendInButtonPressed(
                                                  myProfile.id,
                                                  bookListReached[0].bookingId,
                                                  doctorBookingsModel.bookingId,
                                                ).then((value) {
                                                  if (value.contains("Done")) {
                                                    appointmentProvider
                                                        .patEnded(Appointment(
                                                            doctorBookingsModel:
                                                                doctorBookingsModel,
                                                            patientModel:
                                                                patientModel));
                                                    appointmentProvider
                                                        .sendPatIn(Appointment(
                                                            doctorBookingsModel:
                                                                bookListReached[
                                                                    0],
                                                            patientModel:
                                                                patListReached[
                                                                    0]));
                                                    print(
                                                        "sending patient in with id $index");
                                                    Navigator.of(_context)
                                                        .pop();
                                                    String message =
                                                        "Patient has been marked as Sent In!";
                                                    if (value.contains("Error"))
                                                      message =
                                                          "Error while marking patient as Sent In!";
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content:
                                                                Text(message)));
                                                  } else {
                                                    Navigator.of(_context)
                                                        .pop();
                                                    String message =
                                                        "Error while marking patient as Sent In!";
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content:
                                                                Text(message)));
                                                  }
                                                })
                                              : endAppointmentButtonPressed(
                                                  myProfile.id,
                                                  doctorBookingsModel.bookingId,
                                                ).then((value) {
                                                  scaffoldKey.currentContext!
                                                      .loaderOverlay
                                                      .hide();
                                                  if (value.contains("Done")) {
                                                    Navigator.of(_context)
                                                        .pop();
                                                    String message =
                                                        "Patient's Appointment has been ended!";
                                                    if (value.contains("Error"))
                                                      message =
                                                          "Error while marking patient as Ended!";
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content:
                                                                Text(message)));

                                                    refreshIndicatorKey
                                                        .currentState!
                                                        .show();
                                                  } else {
                                                    Navigator.of(_context)
                                                        .pop();
                                                    return Center(
                                                      child: SpinKitPouringHourGlass(
                                                          color: Colors.grey,
                                                          size:
                                                              getProportionateScreenWidth(
                                                                  100)),
                                                    );
                                                  }
                                                });
                                          ;
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
                              child: Text("Send Next",
                                  style: GoogleFonts.publicSans(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            minimumSize: Size(0, 0),
                            side: BorderSide(width: 0.0, color: Colors.black),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
