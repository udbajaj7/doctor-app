import 'dart:io';
import 'package:doctor/screens/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doctor/Models/DoctorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/urls.dart';
import '../../providers/httpClientProvider.dart';
import '../homeScreen/homeScreen.dart';
import '../otp/components/error_dialog.dart';

String? checkFiledEmpty(String value) {
  if (value.isEmpty)
    return "Enter a valid Input";
  else
    return null;
}

class EditProfileScreen extends StatefulWidget {
  final String phoneNumber;
  EditProfileScreen(this.phoneNumber);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String category = myProfile.category;
  bool correctTimingOrNot = true;
  late TimeOfDay startingSelectedTime;
  late TimeOfDay endingSelectedTime;
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
  bool hidePassword = true;
  bool isCitiesLoaded = false;
  List<String> cities = [], timings = [];
  late String gender;
  late Future<List<dynamic>> getCityFuture;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<bool> sitOrNot = List.generate(7, (index) => false);
  List<bool> has2Slots = List.generate(7, (index) => false),
      has3Slots = List.generate(7, (index) => false);

  @override
  void initState() {
    super.initState();
    doctorInfo = DoctorModel.copyWith(myProfile);
    enterValues();
  }

  List<bool> computeBools(List<String> list) {
    List<bool> bools = List.generate(7, (index) => false);
    for (int i = 0; i < 7; i++) {
      if (list[i] == "true")
        bools[i] = true;
      else
        bools[i] = false;
    }
    return bools;
  }

  Widget _buildFirstName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First Name",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              initialValue: myProfile.firstName,
              onChanged: (value) => doctorInfo.firstName = value,
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Color.fromARGB(255, 0, 0, 0),
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

  Widget _buildLastName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last Name",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              initialValue: myProfile.lastName,
              onChanged: (value) => doctorInfo.lastName = value,
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

  Widget _buildAge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Age",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              autofocus: true,
              initialValue: myProfile.age.toString(),
              onChanged: (value) => doctorInfo.age = int.parse(value),
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

  List<String> genderList = ["Male", "Female", "Others"];
  String select = myProfile.gender;

  Widget _buildGender() {
    Row addRadioButton(int btnValue, String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.publicSans(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Radio(
            activeColor: Colors.black,
            value: genderList[btnValue],
            groupValue: select,
            onChanged: (value) {
              setState(() {
                select = value.toString();
                doctorInfo.gender = value.toString();
              });
            },
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addRadioButton(0, 'Male'),
                addRadioButton(1, 'Female'),
                addRadioButton(2, 'Others'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Registration No.",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              initialValue: myProfile.registrationNumber,
              onChanged: (value) => doctorInfo.registrationNumber = value,
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

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              initialValue: myProfile.email,
              onChanged: (value) => doctorInfo.email = value,
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

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Category",
          style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
        ),
        DropdownButton<String>(
            value: category,
            items: categoriesAvailable.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                category = value.toString();
                doctorInfo.category = value.toString();
                debugPrint("Treatment selected is $category");
              });
            })
      ]),
    );
  }

  Widget _buildSpecialization() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specialization",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              initialValue: myProfile.specialization,
              onChanged: (value) => doctorInfo.specialization = value,
              cursorColor: Colors.black,
              validator: (value) => checkFiledEmpty(value!),
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

  Widget _buildDegree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Degree",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              initialValue: myProfile.degrees,
              autofocus: true,
              onChanged: (value) => doctorInfo.degrees = value,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              validator: (value) => checkFiledEmpty(value!),
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildCity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "City",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              initialValue: myProfile.city,
              autofocus: true,
              onChanged: (value) => doctorInfo.city = (value),
              cursorColor: Colors.black,
              validator: (value) => checkFiledEmpty(value!),
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
  }

  String convertToString(TimeOfDay timeOfDay) {
    String convertedString = timeOfDay.hour.toString().padLeft(2, "0") +
        timeOfDay.minute.toString().padLeft(2, "0");
    return convertedString;
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
              initialValue: myProfile.clinicName,
              onChanged: (value) => doctorInfo.clinicName = value,
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
              initialValue: myProfile.clinicAddress,
              onChanged: (value) => doctorInfo.clinicAddress = value,
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

  bool autoValidateOrNot = false;

  Widget _buildClinicNumber() {
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
              initialValue: myProfile.contactNumber,
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  autoValidateOrNot = true;
                });
                doctorInfo.contactNumber = (value);
              },
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
              initialValue: myProfile.appointmentFees.toString(),
              autofocus: false,
              onChanged: (value) =>
                  doctorInfo.appointmentFees = int.parse(value),
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
            "Average time for appointment (in mins)",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              enabled: false,
              initialValue: myProfile.avgTime.toString(),
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) => doctorInfo.avgTime = int.parse(value),
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
              value: myProfile.patPerSlot,
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
                  doctorInfo.patPerSlot = int.parse(value.toString());
                });
              }),
        ],
      ),
    );
  }

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
                          } else if (slotNo == 2) {
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
                  doctorInfo.timing[index][slotNo][0] = timeOfDay;
                  startTimesUpdatedOrNot[index][slotNo] = true;
                });
              }
            },
            child: Container(
              color: Color.fromARGB(255, 243, 243, 243),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                //some changinges were made here need to verify
                child: Text(
                  index == 0
                      ? defaultStartTime[index][slotNo].format(context)
                      : defaultStartTime[index][slotNo].format(context),
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
                  doctorInfo.timing[index][slotNo][1] = timeOfDay;
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
                      : defaultEndTime[index][slotNo].format(context),
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
          "Edit Profile",
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
                String finalTime = "";
                List<String> timingToStore = [];
                List<int> startTimingsForTesting = [],
                    endTimingsForTesting = [];
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

                doctorInfo.timeSlots = finalTime;

                if (correctTimingOrNot) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: editDetail(doctorInfo),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              saveDataToSharedPreference(
                                  doctorInfo,
                                  timingToStore,
                                  has2Slots,
                                  has3Slots,
                                  sitOrNot);
                              return HomeScreen();
                            } else {
                              return Center(
                                child: SpinKitCubeGrid(
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                      ));
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
                  "Save & Edit!",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Personal Details",
                    style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                _buildFirstName(),
                SizedBox(
                  height: 20,
                ),
                _buildLastName(),
                SizedBox(
                  height: 20,
                ),
                _buildAge(),
                SizedBox(
                  height: 20,
                ),
                _buildGender(),
                SizedBox(
                  height: 20,
                ),
                _buildReg(),
                SizedBox(
                  height: 20,
                ),
                _buildEmail(),
                SizedBox(
                  height: 20,
                ),
                _buildCategory(),
                SizedBox(
                  height: 20,
                ),
                _buildSpecialization(),
                SizedBox(
                  height: 20,
                ),
                _buildDegree(),
                SizedBox(
                  height: 20,
                ),
                _buildCity(),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  thickness: 0.6,
                  color: Color.fromARGB(255, 234, 234, 234),
                ),
                SizedBox(
                  height: 30,
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
                  height: 20,
                ),
                _buildClinicNumber(),
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
                // SizedBox(
                //   height: 32,
                // ),
                // _buildTreatment()
              ],
            ),
          ),
          key: _formKey,
        ),
      ),
    );
  }
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

Future<String> editDetail(DoctorModel doc) async {
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(editDetailUrl), headers: header, body: doc.toJson2());
  if (response.statusCode == HttpStatus.ok) {
    return "Successfully changed the Details!";
  } else {
    return "Error occurred in changing the details!";
  }
}

TimeOfDay computeSlot(String d) {
  d = d.replaceAll(",", "");
  d = d.padLeft(4, "0");
  int hours = int.parse(d.substring(0, 2));
  int minutes = int.parse(d.substring(2, 4));
  TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
  return slot;
}
