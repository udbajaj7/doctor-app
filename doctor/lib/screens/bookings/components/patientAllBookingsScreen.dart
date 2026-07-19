import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:doctor/Models/DoctorBookings.dart';
import 'package:doctor/Models/MedicalFiles.dart';
import 'package:doctor/Models/PatientModel.dart';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/addPatientScreen/AddPatientScreen.dart';
import 'package:doctor/screens/bookings/components/Helper.dart';
import 'package:doctor/screens/bookings/components/editPatientDialog.dart';
import 'package:doctor/screens/bookings/components/requests.dart';
import 'package:doctor/screens/prescription/viewPrescriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';

import 'imageViewer.dart';

class PatientAllBookingsScreen extends StatefulWidget {
  final PatientModel patientModel;
  final Function refresh;

  PatientAllBookingsScreen(this.patientModel, this.refresh);

  @override
  State<PatientAllBookingsScreen> createState() =>
      _PatientAllBookingsScreenState();
}

class _PatientAllBookingsScreenState extends State<PatientAllBookingsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
        title: Text(
            widget.patientModel.firstName + " " + widget.patientModel.lastName,
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Transform.translate(
          offset: Offset(14, 0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Icon(Icons.chevron_left_outlined, color: Colors.black),
            ),
          ),
        ),
        actions: [
          Transform.translate(
            offset: Offset(-14, 0),
            child: InkWell(
              onTap: () {
                makePhoneCall(widget.patientModel.phoneNumber);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 0, color: Colors.black)),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPatientScreen(
                            firstName: widget.patientModel.firstName,
                            lastName: widget.patientModel.lastName,
                            phoneNumber: widget.patientModel.phoneNumber,
                            age: widget.patientModel.age,
                            gender: widget.patientModel.gender,
                            treatment: "",
                            getEarly: true,
                            refreshIndicatorKey: null)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.84,
                height: MediaQuery.of(context).size.height * 0.06,
                color: Colors.black,
                child: Center(
                    child: Text(
                  "Book Another Appointment",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(24)),
        child: FutureBuilder(
          future: getPatientAllBookings(widget.patientModel.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DoctorBookingsModel> bookingList =
                  snapshot.data as List<DoctorBookingsModel>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Patients Details",
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 18)),
                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => EditPatAlertDialog(
                                patientModel: widget.patientModel,
                                refresh: widget.refresh)),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 0,
                                    color: Colors.black.withOpacity(0.04))),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.014,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Age:",
                                style: GoogleFonts.publicSans(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            Text(widget.patientModel.age.toString(),
                                style: GoogleFonts.publicSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gender:",
                                style: GoogleFonts.publicSans(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            Text(widget.patientModel.gender,
                                style: GoogleFonts.publicSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mobile:",
                                style: GoogleFonts.publicSans(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            SelectableText(
                                widget.patientModel.phoneNumber.toString(),
                                style: GoogleFonts.publicSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(16))
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  Text("Booking Details",
                      style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 18)),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: bookingList.length,
                        itemBuilder: (context, index) {
                          DateTime dateOfBooking = convertStringToDateTime(
                              bookingList[index].date,
                              int.parse(bookingList[index].slotTime));
                          Color color = Color.fromARGB(255, 221, 204, 51);
                          if (DateTime.now().isAfter(dateOfBooking)) {
                            color = Color(0xFF6EC76C);
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(6)),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  subtitle: Text(
                                    bookingList[index].date +
                                        " | " +
                                        computeSlot(int.parse(
                                                bookingList[index].slotTime))
                                            .format(context),
                                    style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 106, 106, 106)),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookingList[index].treatment,
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(8)),
                                      color == Color(0xFF6EC76C)
                                          ? SvgPicture.asset(
                                              "assets/images/Vector.svg",
                                              height:
                                                  getProportionateScreenWidth(
                                                      13),
                                              width:
                                                  getProportionateScreenWidth(
                                                      13))
                                          : SvgPicture.asset(
                                              "assets/images/Group 34003.svg",
                                              height:
                                                  getProportionateScreenWidth(
                                                      13),
                                              width:
                                                  getProportionateScreenWidth(
                                                      13))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => {
                                    showDialog(
                                      context: context,
                                      builder: (_contex) => documentDialog(
                                          scaffoldKey,
                                          bookingList[index].bookingId,
                                          _contex,
                                          true),
                                    )
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/fileSvg.svg",
                                          color: Color(0xFF6366F0)),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(4)),
                                      Text(
                                        bookingList[index].fileAvailable == true
                                            ? "Attached Files"
                                            : "Upload Files",
                                        style: GoogleFonts.publicSans(
                                            fontSize: 12,
                                            color: Color(0xFF6366F0),
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0xFF6366F0),
                                            decorationStyle:
                                                TextDecorationStyle.dotted),
                                      ),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(8)),
                                      InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PrescriptionScreen(
                                                        bookingID:
                                                            bookingList[index]
                                                                .bookingId,
                                                        patName: widget
                                                                .patientModel
                                                                .firstName +
                                                            " " +
                                                            widget.patientModel
                                                                .lastName,
                                                        bookingDate:
                                                            bookingList[index]
                                                                .date))),
                                        child: Text(
                                          "View Prescription",
                                          style: GoogleFonts.publicSans(
                                              fontSize: 12,
                                              color: Color(0xFF6366F0),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0xFF6366F0),
                                              decorationStyle:
                                                  TextDecorationStyle.dotted),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                    color: Color.fromARGB(255, 230, 230, 230),
                                    thickness: 0.6),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else
              return SpinKitPouringHourGlass(color: Colors.grey);
          },
        ),
      ),
    );
  }
}

DateTime convertStringToDateTime(String date, int time) {
  List<String> list = date.split("-");
  int minutes = time % 100;
  int hours = (time / 100).floor();
  DateTime dateTime = DateTime(int.parse(list[2]), int.parse(list[1]),
      int.parse(list[0]), hours, minutes);
  return dateTime;
}

Future<void> makePhoneCall(String phoneNumber) async {
  await FlutterPhoneDirectCaller.callNumber(phoneNumber);
}

AlertDialog documentDialog(
    GlobalKey gk, int bookingId, BuildContext context, bool? filesAvailable) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: SizedBox(
      height: SizeConfig.screenHeight * 0.7,
      width: SizeConfig.screenWidth,
      child: FutureBuilder(
          future: getTreatmentFiles(bookingId),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var p = snapshot.data
                  as Tuple2<List<MedicalFiles>, List<MedicalFiles>>;
              List<MedicalFiles> images = p.item1;
              List<MedicalFiles> documents = p.item2;

              bool bool1 = (images.length != 0),
                  bool2 = (documents.length != 0);

              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          filesAvailable == true
                              ? "Attached files"
                              : "Upload Files",
                          style: GoogleFonts.publicSans(
                              fontSize: getProportionateScreenHeight(20),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: Icon(Icons.upload),
                              onPressed: () async {
                                gk.currentContext!.loaderOverlay.show();
                                String message = "File uploaded succesfully";
                                String response = await uploadFile(bookingId,
                                    context, documents.length + images.length);
                                gk.currentContext!.loaderOverlay.hide();

                                if (response == "Error")
                                  message =
                                      "File could not be added due to some error";
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)));
                                Navigator.of(context).pop();
                              }))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  bool1
                      ? Text(
                          "Image files",
                          style: GoogleFonts.publicSans(
                              fontSize: getProportionateScreenHeight(16),
                              fontWeight: FontWeight.w700),
                        )
                      : SizedBox(height: 0),
                  SizedBox(
                    height: 4,
                  ),
                  bool1
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(8)),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageListView(
                                                      images: images,
                                                      index: index)));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenHeight(12)),
                                      child: Image(
                                          image: Image.memory(
                                        base64Decode(images[index].fileData),
                                        fit: BoxFit.cover,
                                      ).image),
                                    ),
                                  );
                                },
                              )))
                      // child: ListView
                      // .builder(
                      //     itemCount: images.length,
                      //     itemBuilder: (_context, index) {
                      //       print(getProportionateScreenWidth(100));
                      //       print(getProportionateScreenHeight(60));
                      //       print(SizeConfig.screenHeight);
                      //       return Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Container(
                      //             decoration: BoxDecoration(
                      //                 border: Border.all(
                      //                     color: Colors.grey, width: 0.2)),
                      //             height: getProportionateScreenHeight(100),
                      //             width: getProportionateScreenWidth(150),
                      //             child: Image.memory(
                      //               base64Decode(images[index].fileData),
                      //             )),
                      //       );
                      //     },
                      //     scrollDirection: Axis.horizontal),

                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/noresch.png',
                                    width: getProportionateScreenWidth(171),
                                    fit: BoxFit.contain,
                                  ))),
                              Text(
                                "No Images Attached!",
                                style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  bool2
                      ? Text(
                          "Document Files",
                          style: GoogleFonts.publicSans(
                              fontSize: getProportionateScreenHeight(16),
                              fontWeight: FontWeight.w700),
                        )
                      : SizedBox(height: 0),
                  SizedBox(
                    height: 10,
                  ),
                  bool2
                      // ? Expanded(
                      //     child: ListView.builder(
                      //         itemCount: documents.length,
                      //         itemBuilder: (context, index) {
                      //           return ListTile(
                      //             leading: Icon(
                      //               Icons.file_open,
                      //               color: Colors.green,
                      //             ),
                      //             title: Text(documents[index].fileName),
                      //             trailing: Row(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 IconButton(
                      //                     onPressed: () async {
                      //                       var response = await deleteFileApi(
                      //                           bookingId,
                      //                           documents[index].fileName);
                      //                       String message =
                      //                           "File deleted successfully";
                      //                       if (response == "Error")
                      //                         message =
                      //                             "Could not delete file due to some error";
                      //                       ScaffoldMessenger.of(context)
                      //                           .showSnackBar(SnackBar(
                      //                               content: Text(message)));
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     icon: Icon(
                      //                       Icons.delete,
                      //                       color: Colors.red,
                      //                     )),
                      //                 // IconButton(
                      //                 //   icon: Icon(
                      //                 //     Icons.download,
                      //                 //     color: Colors.blue,
                      //                 //   ),
                      //                 //   onPressed: () {
                      //                 //     downloadFile(documents[index]);
                      //                 //   },
                      //                 // ),
                      //               ],
                      //             ),
                      //           );
                      //         }))
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async {
                                  Directory generalDownloadDir =
                                      Directory('/storage/emulated/0/Download');

                                  String path = generalDownloadDir.path +
                                      '/' +
                                      documents[index].fileName;

                                  final status =
                                      await Permission.storage.request();

                                  var state = await Permission
                                      .manageExternalStorage.status;
                                  var state2 = await Permission.storage.status;

                                  if (!state2.isGranted) {
                                    await Permission.storage.request();
                                  }
                                  if (!state.isGranted) {
                                    await Permission.manageExternalStorage
                                        .request();
                                  }

                                  if (status.isGranted || state.isGranted) {
                                    File file = await File(path).create();
                                    Uint8List bytes =
                                        base64Decode(documents[index].fileData);
                                    await file
                                        .writeAsBytes(bytes)
                                        .then((value) => log(value.path));

                                    // bool a =
                                    //     await checkPermissionStatus();
                                    // if (!a) await requestPermission();

                                    await OpenFile.open(path)
                                        .then((value) async {
                                      log(value.message.toString());
                                      var status =
                                          await Permission.photos.request();
                                      if (status.isDenied) {
                                        // We didn't ask for permission yet or the permission has been denied before, but not permanently.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please retry after giving permission!")));
                                      }

// You can can also directly ask the permission about its status.
                                      if (await Permission
                                          .photos.isRestricted) {
                                        // The OS restricts access, for example because of parental controls.
                                        openAppSettings();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please retry after giving permission!")));
                                      }
                                    });
                                  }
                                  // openAppSettings();
                                },
                                leading:
                                    Icon(Icons.file_copy, color: Colors.blue),
                                title: Text(documents[index].fileName,
                                    style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.black)),
                                trailing: Icon(Icons.download),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/noresch.png',
                                    width: getProportionateScreenWidth(171),
                                    fit: BoxFit.contain,
                                  ))),
                              Text(
                                "No Documents Attached!",
                                style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                ],
              );
            }
            return SpinKitPouringHourGlass(color: Colors.grey);
          }),
    ),
  );
}
