import 'dart:convert';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../Models/DoctorModel.dart';
import '../../../providers/httpClientProvider.dart';

class AddSchedule extends StatefulWidget {
  final Function refresh;
  AddSchedule({required this.refresh});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  bool _has2Slots = false, _has3Slots = false;
  late List<TimeOfDay> defaultStartTimes =
      List.filled(3, TimeOfDay(hour: 0, minute: 0));
  late List<TimeOfDay> defaultEndTimes =
      List.filled(3, TimeOfDay(hour: 0, minute: 0));
  List<bool> sitOrNot = List.generate(7, (index) => false);
  List<bool> has2Slots = List.generate(7, (index) => false),
      has3Slots = List.generate(7, (index) => false);

  DoctorModel doctorInfo = DoctorModel(
      id: -1,
      firstName: "",
      lastName: "",
      gender: "",
      age: -1,
      phoneNumber: "",
      email: "",
      registrationNumber: "",
      specialization: "",
      degrees: "",
      appointmentFees: -1,
      clinicName: "",
      clinicAddress: "",
      city: "",
      avgTime: -1,
      patPerSlot: -1,
      timing: [],
      category: "",
      contactNumber: "");

  List<List<TimeOfDay>> defaultStartTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<List<TimeOfDay>> defaultEndTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<List<bool>> startTimesUpdatedOrNot =
      List.generate(7, (index) => List.generate(3, (index) => false));
  List<List<bool>> endTimesUpdatedOrNot =
      List.generate(7, (index) => List.generate(3, (index) => false));

  void enterValues() {
    bool sitOrNotBool = false;
    for (int i = 0; i < 7; i++) {
      sitOrNotBool = false;
      for (int j = 0; j < 3; j++) {
        defaultStartTime[i][j] =
            computeSlot(myProfile.timing[i][j][0].toString());
        defaultEndTime[i][j] =
            computeSlot(myProfile.timing[i][j][1].toString());
        print("$i $j ${defaultStartTime[i][j]}");
        if (defaultStartTime[i][j].hour + defaultStartTime[i][j].minute > 0 ||
            defaultEndTime[i][j].hour + defaultEndTime[i][j].minute > 0)
          sitOrNotBool = true;

        if (j == 1) {
          if (defaultStartTime[i][j].hour + defaultStartTime[i][j].minute > 0 ||
              defaultEndTime[i][j].hour + defaultEndTime[i][j].minute > 0)
            has2Slots[i] = true;
        }
        if (j == 2) {
          if (defaultStartTime[i][j].hour + defaultStartTime[i][j].minute > 0 ||
              defaultEndTime[i][j].hour + defaultEndTime[i][j].minute > 0)
            has3Slots[i] = true;
        }
      }
      sitOrNot[i] = sitOrNotBool;
    }

    initialize(DateTime.now().weekday);
  }

  void initialize(int weekDay) {
    weekDay--;
    _has2Slots = has2Slots[weekDay];
    _has3Slots = has3Slots[weekDay];
    defaultStartTimes = defaultStartTime[weekDay];
    defaultEndTimes = defaultEndTime[weekDay];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    doctorInfo = DoctorModel.copyWith(myProfile);
    enterValues();
  }

  TimeOfDay computeSlot(String d) {
    d = d.replaceAll(",", "");
    d = d.padLeft(4, "0");
    int hours = int.parse(d.substring(0, 2));
    int minutes = int.parse(d.substring(2, 4));
    TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
    return slot;
  }

  Padding timeSlot(int slotNo) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          slotNo == 0
              ? SizedBox(
                  width: 25,
                )
              : ClipOval(
                  child: Material(
                    color: Color.fromARGB(255, 255, 74, 74),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (slotNo == 1) {
                            _has2Slots = false;
                            defaultStartTimes[1] =
                                TimeOfDay(hour: 0, minute: 0);
                            defaultEndTimes[1] = TimeOfDay(hour: 0, minute: 0);
                          }
                          if (slotNo == 2) {
                            _has3Slots = false;
                            defaultStartTimes[2] =
                                TimeOfDay(hour: 0, minute: 0);
                            defaultEndTimes[2] = TimeOfDay(hour: 0, minute: 0);
                          }
                        });
                      },
                      child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 14,
                          )),
                    ),
                  ),
                ),
          InkWell(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: defaultStartTimes[slotNo],
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (context, childWidget) {
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(),
                      child: childWidget!);
                },
              );
              if (timeOfDay != null) {
                setState(() {
                  defaultStartTimes[slotNo] = timeOfDay;
                });
              }
            },
            child: Container(
              color: Color.fromARGB(255, 243, 243, 243),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: Text(
                  defaultStartTimes[slotNo].format(context),
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          Text("TO",
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color.fromARGB(255, 144, 144, 144))),
          InkWell(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: defaultEndTimes[slotNo],
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (context, childWidget) {
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(),
                      child: childWidget!);
                },
              );
              if (timeOfDay != null) {
                setState(() {
                  defaultEndTimes[slotNo] = timeOfDay;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Color.fromARGB(255, 243, 243, 243),
              child: Center(
                child: Text(
                  defaultEndTimes[slotNo].format(context),
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          slotNo != 2
              ? ClipOval(
                  child: Material(
                    color: Colors.black,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (slotNo == 0) {
                            _has2Slots = true;
                          } else if (slotNo == 1) {
                            _has3Slots = true;
                          }
                        });
                      },
                      child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          )),
                    ),
                  ),
                )
              : SizedBox(
                  width: 25,
                )
        ],
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          "Reschedule Clinic \n         Timings",
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
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 27,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Date",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: 16,
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
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                              margin: EdgeInsets.all(2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  day.day.toString(),
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ));
                        },
                      ),
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 134, 134, 134),
                              fontSize: 10.47)),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                          initialize(selectedDay.weekday);
                        });
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDate, day);
                      },
                      calendarFormat: CalendarFormat.month,
                      currentDay: DateTime.now(),
                      calendarStyle: CalendarStyle(
                          selectedTextStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 14.66),
                          canMarkersOverflow: true,
                          defaultTextStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 64, 64, 64),
                              fontSize: 14.66),
                          selectedDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle)),
                      weekendDays: List.filled(0, DateTime.march),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16),
                        rightChevronMargin: EdgeInsets.only(right: 18),
                        leftChevronMargin: EdgeInsets.only(left: 18),
                        rightChevronIcon: Container(
                          height: 36.66,
                          width: 36.66,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 200, 200, 200),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(style: BorderStyle.none)),
                          child: Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        leftChevronIcon: Container(
                          height: 36.66,
                          width: 36.66,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 200, 200, 200),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(style: BorderStyle.none)),
                          child: Icon(
                            Icons.chevron_left_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 27,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Timings",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      timeSlot(0),
                      _has2Slots == true
                          ? timeSlot(1)
                          : SizedBox(
                              height: 0,
                            ),
                      _has3Slots == true
                          ? timeSlot(2)
                          : SizedBox(
                              height: 0,
                            ),
                    ],
                  )),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    List<String> startTimingToBeFed = [], endTimingToBeFed = [];
                    String finalTime = "";
                    defaultStartTimes.forEach((dayElement) {
                      if (dayElement.hour == 0 && dayElement.minute == 0) {
                        startTimingToBeFed.add("0,");
                      } else {
                        startTimingToBeFed.add(timeToString(dayElement) + ",");
                      }
                    });
                    debugPrint(startTimingToBeFed.toString());
                    defaultEndTimes.forEach((dayElement) {
                      if (dayElement.hour == 0 && dayElement.minute == 0) {
                        endTimingToBeFed.add("0,");
                      } else {
                        endTimingToBeFed.add(timeToString(dayElement) + ",");
                      }
                    });
                    debugPrint(endTimingToBeFed.toString());
                    for (var i = 0; i < 3; i++) {
                      finalTime += startTimingToBeFed[i];
                      finalTime += endTimingToBeFed[i];
                    }

                    finalTime = finalTime.substring(0, finalTime.length - 1);
                    String leaveStatus = await addResch(
                        myProfile.id, dateToString(_selectedDate), finalTime);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(leaveStatus)));
                    widget.refresh();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Center(
                        child: Text(
                          "Save",
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> addResch(int docId, String date, String timing) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(addReschUrl),
      body: jsonEncode(
          <String, dynamic>{"doc_id": docId, "date": date, "timing": timing}),
      headers: header);
  if (response.statusCode == 200) {
    return "Timing Rescheduled Successfully!";
  } else {
    return "Some error occurred in Rescheduling Timing!";
  }
}
