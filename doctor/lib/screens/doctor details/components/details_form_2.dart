import 'dart:convert';
import 'dart:io';
import 'package:doctor/screens/doctor%20details/components/details_form_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/DoctorModel.dart';
import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';
import '../../homeScreen/homeScreen.dart';
import '../../otp/components/error_dialog.dart';

class DetailsForm2 extends StatefulWidget {
  final DoctorModel doctorInfo;
  DetailsForm2({required this.doctorInfo});
  @override
  _DetailsForm2State createState() => _DetailsForm2State();
}

class _DetailsForm2State extends State<DetailsForm2> {
  bool correctTimingOrNot = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List<List<TimeOfDay>> defaultStartTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<List<TimeOfDay>> defaultEndTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<List<bool>> startTimesUpdatedOrNot =
      List.generate(7, (index) => List.generate(3, (index) => false));
  List<List<bool>> endTimesUpdatedOrNot =
      List.generate(7, (index) => List.generate(3, (index) => false));

  String convertToString(TimeOfDay timeOfDay) {
    String convertedString = timeOfDay.hour.toString().padLeft(2, "0") +
        timeOfDay.minute.toString().padLeft(2, "0");
    return convertedString;
  }

  TextEditingController c = TextEditingController();
  bool autoValidateOrNot = false;

  Widget _buildClinicPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Number (Reception)",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autovalidateMode: autoValidateOrNot
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              onChanged: (value) {
                setState(() {
                  autoValidateOrNot = true;
                });
                widget.doctorInfo.contactNumber = (value);
                //As can be a landline number

                // if (value.length == 10) {
                //   FocusManager.instance.primaryFocus.unfocus();
                // }
              },
              controller: c,
              keyboardType: TextInputType.number,
              autofocus: false,
              validator: (value) {
                if ((value != null &&
                        !(value.length == 10 || value.length == 11)) ||
                    value!.isEmpty)
                  return "Enter a valid Contact Number";
                else
                  return null;
              },
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              )),
        ],
      ),
    );
  }

  Widget _buildcName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clinic Name",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: false,
              onChanged: (value) => widget.doctorInfo.clinicName = value,
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildcAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clinic Full Address",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: false,
              onChanged: (value) => widget.doctorInfo.clinicAddress = value,
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildFees() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Fees",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) =>
                  widget.doctorInfo.appointmentFees = int.parse(value),
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildAvg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Average time for Checkup (in mins)",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) =>
                  widget.doctorInfo.avgTime = int.parse(value),
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildPatPerSlot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patients per Slot",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          DropdownButton(
              hint: Text("Choose number of patients per slot"),
              value: widget.doctorInfo.patPerSlot,
              items: [
                DropdownMenuItem(
                  child: Text("1"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("2"),
                  value: 2,
                )
              ],
              onChanged: (value) {
                setState(() {
                  print(value);
                  widget.doctorInfo.patPerSlot = int.parse(value.toString());
                });
              }),
        ],
      ),
    );
  }

  List<bool> has2Slots = List.filled(7, false),
      has3Slots = List.filled(7, false);

  Widget timeSlot(int index, int slotNo) {
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
                            has2Slots[index] = false;
                            defaultStartTime[index][1] =
                                TimeOfDay(hour: 0, minute: 0);
                            defaultEndTime[index][1] =
                                TimeOfDay(hour: 0, minute: 0);
                          }
                          if (slotNo == 2) {
                            has3Slots[index] = false;
                            defaultStartTime[index][2] =
                                TimeOfDay(hour: 0, minute: 0);
                            defaultEndTime[index][2] =
                                TimeOfDay(hour: 0, minute: 0);
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
                initialTime: index != 0
                    ? TimeOfDay(
                        hour: defaultStartTime[index - 1][slotNo].hour,
                        minute: defaultStartTime[index - 1][slotNo].minute)
                    : TimeOfDay(
                        hour: defaultStartTime[index][slotNo].hour,
                        minute: defaultStartTime[index][slotNo].minute),
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (context, childWidget) {
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(),
                      child: childWidget!);
                },
              );
              if (timeOfDay != null) {
                setState(() {
                  debugPrint("Setting the state of Index: " +
                      index.toString() +
                      " and slotNo: " +
                      slotNo.toString());
                  defaultStartTime[index][slotNo] = timeOfDay;
                  widget.doctorInfo.timing[index][slotNo][0] = timeOfDay;
                  startTimesUpdatedOrNot[index][slotNo] = true;
                });
              }
            },
            child: Container(
              color: Color.fromARGB(255, 243, 243, 243),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: Text(
                  index == 0
                      ? defaultStartTime[index][slotNo].format(context)
                      : (startTimesUpdatedOrNot[index][slotNo] == false
                          ? defaultStartTime[index - 1][slotNo].format(context)
                          : defaultStartTime[index][slotNo].format(context)),
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
                initialTime: index != 0
                    ? TimeOfDay(
                        hour: defaultEndTime[index - 1][slotNo].hour,
                        minute: defaultEndTime[index - 1][slotNo].minute)
                    : TimeOfDay(
                        hour: defaultEndTime[index][slotNo].hour,
                        minute: defaultEndTime[index][slotNo].minute),
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (context, childWidget) {
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(),
                      child: childWidget!);
                },
              );
              if (timeOfDay != null) {
                setState(() {
                  defaultEndTime[index][slotNo] = timeOfDay;
                  widget.doctorInfo.timing[index][slotNo][1] = timeOfDay;
                  endTimesUpdatedOrNot[index][slotNo] = true;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Color.fromARGB(255, 243, 243, 243),
              child: Center(
                child: Text(
                  index == 0
                      ? defaultEndTime[index][slotNo].format(context)
                      : (endTimesUpdatedOrNot[index][slotNo] == false
                          ? defaultEndTime[index - 1][slotNo].format(context)
                          : defaultEndTime[index][slotNo].format(context)),
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
                            has2Slots[index] = true;
                          } else if (slotNo == 1) {
                            has3Slots[index] = true;
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

  List<bool> sitOrNot = List.filled(7, false);

  Widget _buildHours() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cinic Working Hours",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          tristate: false,
                          value: sitOrNot[index],
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onChanged: (value) {
                            value!
                                ? setState(() {
                                    sitOrNot[index] = value;
                                    if (index != 0) {
                                      if (has2Slots[index - 1])
                                        has2Slots[index] = true;
                                      if (has3Slots[index - 1])
                                        has3Slots[index] = true;
                                      for (int i = 0; i < 3; i++) {
                                        if (defaultStartTime[index - 1][i] !=
                                            TimeOfDay(hour: 0, minute: 0)) {
                                          defaultStartTime[index][i] =
                                              defaultStartTime[index - 1][i];
                                        }

                                        if (defaultEndTime[index - 1][i] !=
                                            TimeOfDay(hour: 0, minute: 0)) {
                                          defaultEndTime[index][i] =
                                              defaultEndTime[index - 1][i];
                                        }
                                      }
                                    }
                                  })
                                : setState(() {
                                    sitOrNot[index] = value;
                                    for (int i = 0; i < 3; i++) {
                                      defaultStartTime[index][i] =
                                          TimeOfDay(hour: 0, minute: 0);
                                      defaultEndTime[index][i] =
                                          TimeOfDay(hour: 0, minute: 0);
                                    }
                                  });
                          }),
                      Text(
                        weekdays[index],
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sitOrNot[index]
                          ? timeSlot(index, 0)
                          : SizedBox(
                              height: 0,
                            ),
                      (has2Slots[index] && sitOrNot[index]) == true
                          ? timeSlot(index, 1)
                          : SizedBox(
                              height: 0,
                            ),
                      (has3Slots[index] && sitOrNot[index]) == true
                          ? timeSlot(index, 2)
                          : SizedBox(
                              height: 0,
                            ),
                    ],
                  )
                ],
              );
            },
            itemCount: 7,
          )
        ],
      ),
    );
  }

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
          "Getting Started",
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
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState!.save();
                List<String> startTimingToBeFed = [], endTimingToBeFed = [];
                List<int> startTimingsForTesting = [],
                    endTimingsForTesting = [];
                String finalTime = "";
                List<String> timingToStore = [];
                defaultStartTime.forEach((dayElement) {
                  dayElement.forEach((slotElement) {
                    if (slotElement.hour == 0 && slotElement.minute == 0) {
                      startTimingToBeFed.add("0,");
                      startTimingsForTesting.add(0);
                    } else {
                      startTimingToBeFed
                          .add(convertToString(slotElement) + ",");
                      startTimingsForTesting
                          .add(int.parse(convertToString(slotElement)));
                    }
                  });
                });
                defaultEndTime.forEach((dayElement) {
                  dayElement.forEach((slotElement) {
                    if (slotElement.hour == 0 && slotElement.minute == 0) {
                      endTimingToBeFed.add("0,");
                      endTimingsForTesting.add(0);
                    } else {
                      endTimingToBeFed.add(convertToString(slotElement) + ",");
                      endTimingsForTesting
                          .add(int.parse(convertToString(slotElement)));
                    }
                  });
                });

                for (int i = 0; i < 7; i++) {
                  for (int j = 0; j < 3; j++) {
                    if (startTimingsForTesting[3 * i + j] >
                        endTimingsForTesting[3 * i + j]) {
                      correctTimingOrNot = false;
                      break;
                    } else {
                      if (j == 1) {
                        if (endTimingsForTesting[3 * i] >
                                startTimingsForTesting[3 * i + 1] &&
                            startTimingsForTesting[3 * i + 1] != 0) {
                          correctTimingOrNot = false;
                          break;
                        }
                      }
                      if (j == 2) {
                        if (endTimingsForTesting[3 * i + 1] >
                                startTimingsForTesting[3 * i + 2] &&
                            startTimingsForTesting[3 * i + 2] != 0) {
                          correctTimingOrNot = false;
                          break;
                        }
                      }
                      finalTime += startTimingToBeFed[3 * i + j];
                      finalTime += endTimingToBeFed[3 * i + j];
                    }
                  }
                }

                timingToStore += startTimingToBeFed;
                timingToStore += endTimingToBeFed;

                finalTime = finalTime.substring(0, finalTime.length - 1);

                widget.doctorInfo.timeSlots = finalTime;
                debugPrint(finalTime);

                if (correctTimingOrNot) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: _sendDoctorDetail(widget.doctorInfo),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.toString() != "") {
                                final jsonResponse =
                                    json.decode(snapshot.data.toString());
                                DocId docId = new DocId.fromJson(jsonResponse);
                                debugPrint("DocId:" + docId.docId.toString());
                                widget.doctorInfo.id = docId.docId;
                                prefs.setBool('isLoggedIn', true);
                                prefs.setInt('myDocId', docId.docId);
                                prefs.setInt("currentDocId", docId.docId);
                                String prefsDocIds =
                                    prefs.getString("DocIds") ?? "";
                                prefs.setString("DocIds",
                                    prefsDocIds + docId.docId.toString() + ",");

                                String docNames =
                                    prefs.getString("DocNames") ?? "";
                                prefs.setString(
                                    "DocNames",
                                    docNames +
                                        widget.doctorInfo.firstName +
                                        ",");
                                widget.doctorInfo.id = docId.docId;
                                metaData.isLoggedIn = true;

                                saveDataToSharedPreference(
                                    widget.doctorInfo,
                                    timingToStore,
                                    has2Slots,
                                    has3Slots,
                                    sitOrNot);
                                return HomeScreen();
                              } else {
                                return ErrorDialog(
                                    context,
                                    "Some error occurred in adding doctor!",
                                    false);
                              }
                            } else {
                              return Center(
                                child: SpinKitCubeGrid(
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      (route) => false);
                } else {
                  correctTimingOrNot = true;
                  startTimingToBeFed.clear();
                  endTimingToBeFed.clear();
                  finalTime = '';
                  timingToStore.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ErrorDialog(
                              context,
                              "The timings entered are overlapping/incorrect, please check and try again!",
                              false)));
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.84,
                height: MediaQuery.of(context).size.height * 0.06,
                color: Colors.black,
                child: Center(
                    child: Text(
                  "Save",
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
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Clinic Details",
                    style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                _buildcName(),
                SizedBox(
                  height: 20,
                ),
                _buildcAddress(),
                SizedBox(
                  height: 28,
                ),
                _buildClinicPhoneNumber(),
                SizedBox(
                  height: 20,
                ),
                _buildFees(),
                SizedBox(
                  height: 20,
                ),
                _buildAvg(),
                SizedBox(
                  height: 20,
                ),
                _buildPatPerSlot(),
                SizedBox(
                  height: 20,
                ),
                _buildHours(),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          key: _formKey,
        ),
      ),
    );
  }

  void saveDataToSharedPreference(DoctorModel doctorInfo, List<String> s,
      List<bool> slot2, List<bool> slot3, List<bool> sit) {
    List<String> sitOrNot = List.generate(7, (index) => ""),
        has3Slots = List.generate(7, (index) => ""),
        has2Slots = List.generate(7, (index) => "");
    for (var i = 0; i < sit.length; i++) {
      sitOrNot[i] = sit[i].toString();
      has2Slots[i] = slot2[i].toString();
      has3Slots[i] = slot3[i].toString();
    }
    prefs.setString('category', doctorInfo.category);
    prefs.setInt('age', doctorInfo.age);
    prefs.setInt('appointmentFees', doctorInfo.appointmentFees);
    prefs.setString('city', doctorInfo.city);
    prefs.setString('clinicAddress', doctorInfo.clinicAddress);
    prefs.setString('clinicName', doctorInfo.clinicName);
    prefs.setString('degrees', doctorInfo.degrees);
    prefs.setString('email', doctorInfo.email);
    prefs.setString('firstName', doctorInfo.firstName);
    prefs.setString('gender', doctorInfo.gender);
    prefs.setString('lastName', doctorInfo.lastName);
    prefs.setString('phoneNumber', doctorInfo.phoneNumber);
    prefs.setString('registrationNumber', doctorInfo.registrationNumber);
    prefs.setString('specialization', doctorInfo.specialization);
    prefs.setInt('id', doctorInfo.id);
    prefs.setInt('pat_per_slot', doctorInfo.patPerSlot);
    prefs.setInt('avgTime', doctorInfo.avgTime);
    prefs.setStringList("timings", s);
    prefs.setStringList("slot2", has2Slots);
    prefs.setStringList("slot3", has3Slots);
    prefs.setStringList("sit", sitOrNot);
    prefs.setString("contact_number", doctorInfo.contactNumber);
    myProfile = DoctorModel.copyWith(doctorInfo);
  }

  InputDecoration getDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 14),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    );
  }
}

Future<String> _sendDoctorDetail(DoctorModel doc) async {
  initializeHeader();
  print("sending data + $header");
  print(doc.toJson1());
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(addDoctorUrl), headers: header, body: doc.toJson1());
  print(doc.toJson1());
  print(response.statusCode);
  print(json.decode(response.body).toString());
  if (response.statusCode == HttpStatus.ok) {
    print("Signup data sent to the backend");
    print("\n response code " + response.statusCode.toString());
    return response.body;
  } else {
    print(response.toString());
    return "";
  }
}

class DocId {
  int docId;
  DocId({required this.docId});

  factory DocId.fromJson(Map<String, dynamic> parsedJson) {
    return DocId(docId: parsedJson['doc_id']);
  }
}
