import 'dart:convert';
import 'dart:ui';
import 'package:doctor/screens/bookings/components/patientAllBookingsScreen.dart';
import 'package:doctor/screens/bookings/components/requests.dart';
import 'package:doctor/screens/homeScreen/components/duesScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import '../../../providers/httpClientProvider.dart';

class Body extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  Body({required this.refreshIndicatorKey});
  @override
  State<Body> createState() => _BodyState();
}

class Patient {
  String name;
  TimeOfDay bookingTime;

  Patient({required this.name, required this.bookingTime});
}

class _BodyState extends State<Body> {
  int marked = 0;
  DateTime chosenDate = DateTime.now();
  DateTime dateTime = DateTime.now();

  void f() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String month = DateFormat.MMMM().format(dateTime);
    int day = dateTime.day;
    DateTime x1 = DateTime(dateTime.year, dateTime.month, 0).toUtc();
    int daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0)
        .toUtc()
        .difference(x1)
        .inDays;
    List<int> days = [day];
    if (daysInMonth < (day + 6)) {
      int diff = (day + 6) - daysInMonth;
      for (int i = 1; i < (7 - diff); i++) {
        days.add(day + i);
      }
      for (int i = 1; i <= diff; i++) {
        days.add(i);
      }
    } else {
      for (int i = 1; i < 7; i++) {
        days.add(day + i);
      }
    }
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            month,
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: height * 0.11,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          marked = index;
                          chosenDate = dateTime.add(Duration(days: index));
                          debugPrint(chosenDate.toString());
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: height * 0.11,
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height:
                                    MediaQuery.of(context).size.width * 0.06,
                                decoration: BoxDecoration(
                                  color: marked == index
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              color:
                                  marked == index ? Colors.black : Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      DateFormat("EEEE")
                                          .format(dateTime
                                              .add(Duration(days: index)))
                                          .substring(0, 3),
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: marked == index
                                              ? Colors.white
                                              : Colors.black)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(days[index].toString(),
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: marked == index
                                              ? Colors.white
                                              : Colors.black))
                                ],
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height:
                                    MediaQuery.of(context).size.width * 0.06,
                                decoration: BoxDecoration(
                                  color: marked == index
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("                 "),
            Text(
              DateFormat("EEEE").format(chosenDate) +
                  " " +
                  DateFormat.MMMM().format(chosenDate) +
                  " " +
                  chosenDate.day.toString() +
                  ", " +
                  chosenDate.year.toString(),
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black),
            ),
            InkWell(
              onTap: () async {
                final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101));
                if (date != null && date != dateTime) {
                  setState(() {
                    dateTime = date;
                    chosenDate = date;
                    marked = 0;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF000000).withOpacity(0.04),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.calendar_month_sharp,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.35),
                    child: Divider(
                        color: Color.fromARGB(255, 207, 207, 207),
                        thickness: 5),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    "Patients List",
                    style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  FutureBuilder(
                    future: getBookings(myProfile.id, dateToString(chosenDate)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        Map<String, List> map =
                            snapshot.data as Map<String, List>;
                        List<PatientModel> patList =
                            map["pats"] as List<PatientModel>;
                        print("length of patList is ${patList.length}");
                        bool hasData = patList.length == 0 ? false : true;
                        List<DoctorBookingsModel> bookList =
                            map["books"] as List<DoctorBookingsModel>;
                        return hasData == true
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: patList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        PatientAllBookingsScreen(
                                                            patList[index], f),
                                                  ));
                                                },
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  patList[index].firstName +
                                                      " " +
                                                      patList[index].lastName,
                                                  style: GoogleFonts.publicSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                subtitle: Text(
                                                  computeSlot(bookList[index]
                                                          .slotTime)
                                                      .format(context),
                                                  style: GoogleFonts.publicSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                trailing: Container(
                                                  height: 47,
                                                  width: 47,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF000000)
                                                        .withOpacity(0.04),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: GoogleFonts
                                                          .publicSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.settings),
                                              onPressed: () {
                                                getBalance(bookList[index]
                                                        .bookingId)
                                                    .then((value) {
                                                  if (value == null)
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Could not open the finances due to some error")));
                                                  else
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: DuesScreen(
                                                            refreshIndicatorKey:
                                                                widget
                                                                    .refreshIndicatorKey,
                                                            notes:
                                                                bookList[index]
                                                                    .notes,
                                                            bookingId:
                                                                bookList[index]
                                                                    .bookingId,
                                                            balance:
                                                                value.item1,
                                                            fName:
                                                                patList[index]
                                                                    .firstName,
                                                            lName:
                                                                patList[index]
                                                                    .lastName,
                                                            age: patList[index]
                                                                .age,
                                                            phoneNumber:
                                                                patList[index]
                                                                    .phoneNumber,
                                                            gender:
                                                                patList[index]
                                                                    .gender,
                                                            treatment: '',
                                                            installment:
                                                                value.item2,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: Color.fromARGB(
                                              255, 234, 234, 234),
                                          thickness: 0.6),
                                    ],
                                  );
                                },
                                physics: AlwaysScrollableScrollPhysics(),
                              )
                            : (Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Image.asset(
                                      "assets/images/nopat.png",
                                      width: 150,
                                      height: 150,
                                    ),
                                    Text(
                                      "No Bookings on this Day!",
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ));
                      } else {
                        return Column(
                          children: [
                            SpinKitPouringHourGlass(
                              color: Colors.grey,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4)
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<Map<String, List>> getBookings(int docId, String date) async {
  print("fetching all bookings for doctor $docId");
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(getBookingsUrl),
      body: jsonEncode(<String, dynamic>{"doc_id": docId, "date": date}),
      headers: header);

  var jsonResponse = json.decode(response.body.toString());
  if (response.statusCode == 200) {
    BookingResponse jsonResp = BookingResponse.fromJson(jsonResponse);

    var bookList = jsonResp.bookings;
    var patList = jsonResp.patients;
    print(bookList);
    print(patList);
    return {"pats": patList, "books": bookList};
  } else
    return {"pats": [], "books": []};
}

class BookingResponse {
  final List<PatientModel> patients;
  final List<DoctorBookingsModel> bookings;

  BookingResponse({required this.patients, required this.bookings});

  factory BookingResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["Patients"] as List;
    List<PatientModel> patList =
        list.map((i) => PatientModel.fromJson(i)).toList();
    var list1 = parsedJson["Bookings"] as List;
    List<DoctorBookingsModel> bookingsList =
        list1.map((i) => DoctorBookingsModel.fromJson(i)).toList();
    return BookingResponse(patients: patList, bookings: bookingsList);
  }
}

TimeOfDay computeSlot(String d) {
  d = d.padLeft(4, "0");
  int hours = int.parse(d.substring(0, 2));
  int minutes = int.parse(d.substring(2, 4));
  TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
  return slot;
}
