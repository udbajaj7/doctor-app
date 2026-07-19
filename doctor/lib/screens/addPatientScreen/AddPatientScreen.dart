import 'dart:convert';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../homeScreen/homeScreen.dart';

class AddPatientScreen extends StatefulWidget {
  String firstName = "", lastName = "", phoneNumber = "", gender = "Male";
  int? age;
  String treatment;
  bool getEarly = true;
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  AddPatientScreen(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.age,
      required this.gender,
      required this.treatment,
      required this.getEarly,
      required this.refreshIndicatorKey});
  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  TextEditingController c = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool useTreatmentOrNot;
  String treatment = "Checkup";
  final itemkey = GlobalKey();
  final itemController = ItemScrollController();
  List<String> genderList = ["Male", "Female", "Others"];
  String select = "Male";
  late bool pop;
  DateTime lastRefreshTime = DateTime.now();

  InputDecoration inputDecoration = InputDecoration(
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black, style: BorderStyle.solid)),
      focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black, style: BorderStyle.solid)),
      border: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black, style: BorderStyle.solid)));
  TextStyle headingStyle = GoogleFonts.publicSans(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey);
  TextStyle inputStyle = GoogleFonts.publicSans(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
  late TimeOfDay selectedSlot;

  late int marked;
  int numSlots = 1;

  List<DateTime> datesAvailable = [];
  late Future<List<DateTime>> getAvailableDates;
  DateTime selectedDate = DateTime(-1);
  late Tuple2<int, TimeOfDay> selectedSlotForBooking; //<batch,slot time>
  TextEditingController _controller = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  late Future getEaliestSlotFutureResponse;
  late Future? getAvailSlotsFutureResponse;
  String selectedSalutation = "Mr.";
  List<String> salutationsList = ['Mr.', 'Ms.'];

  @override
  void initState() {
    super.initState();
    marked = 0;
    pop = widget.firstName == "" ? false : true;
    numSlots = 1;
    _controller.text = "1";
    getAvailableDates = _getAvailDates(myProfile.id);
    getEaliestSlotFutureResponse = getEarliestSlot(myProfile.id);
    c.text = widget.phoneNumber;
    print(widget.treatment);
    print(widget.treatment.length);
    treatment = widget.treatment.length == 0 ? treatment : widget.treatment;
  }

  @override
  Widget build(BuildContext context) {
    if (myProfile.category == 'Dentist') {
      useTreatmentOrNot = true;
    } else {
      useTreatmentOrNot = false;
    }
    select = widget.gender.length == 0 ? "Male" : widget.gender;
    widget.gender = select;
    int day = DateTime.now().day;
    DateTime x1 =
        DateTime(DateTime.now().year, DateTime.now().month, 0).toUtc();
    int daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
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

    return Container(
      color: Colors.white,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth * 0.56,
      child: LoaderOverlay(
        overlayWidget: Center(
            child: SpinKitPouringHourGlass(
          color: Colors.grey,
        )),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              title: Text(
                "Add Patient",
                style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 20),
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
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenWidth(100)),
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
          backgroundColor: Colors.white,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(24),
                    horizontal: getProportionateScreenWidth(24)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient Details",
                        style: GoogleFonts.publicSans(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildFirstName(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildLastName(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildMobileNo(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildAge(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildGender(),
                      docTreatmentsAvailable.length != 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildTreatment(),
                                ])
                          : SizedBox(height: 0),
                      Divider(
                        thickness: 0.6,
                        color: Color.fromARGB(255, 234, 234, 234),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Book earliest slot",
                            style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Checkbox(
                              activeColor: Colors.black,
                              tristate: false,
                              value: widget.getEarly,
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              onChanged: (value) {
                                setState(() {
                                  print(
                                      "setting state for get early and calling set state");
                                  widget.getEarly = value!;
                                });
                              }),
                        ],
                      ),
                      widget.getEarly == true
                          ? FutureBuilder(
                              future: getEaliestSlotFutureResponse,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  EarlyResponse earlyResponse =
                                      snapshot.data as EarlyResponse;

                                  var estimatedTime = "No Slots Left!";
                                  if (earlyResponse.slotTime != -1)
                                    estimatedTime =
                                        earlyResponse.estTime.toString();
                                  String amOrpm = "";
                                  if (estimatedTime != "No Slots Left!") {
                                    print("Estimated time is $estimatedTime");
                                    var timings = estimatedTime.split(":");
                                    var intTimings = [
                                      int.parse(timings[0]),
                                      int.parse(timings[1])
                                    ];

                                    if (intTimings[0] >= 12) {
                                      amOrpm = " PM";
                                    } else
                                      amOrpm = " AM";

                                    if (intTimings[0] == 0)
                                      intTimings[0] = intTimings[0] + 12;
                                    else if (intTimings[0] > 12)
                                      intTimings[0] = intTimings[0] - 12;

                                    estimatedTime = intTimings[0].toString() +
                                        ":" +
                                        timings[1];
                                  }

                                  return Column(
                                    children: [
                                      Text(
                                        "Estimated Time of \nAppointment : " +
                                            estimatedTime +
                                            amOrpm,
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: TextButton(
                                            child: Text(
                                              "Add Patient",
                                              style: GoogleFonts.publicSans(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            onPressed: () {
                                              print(
                                                  "add patient api is called for earliest slot");

                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);

                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              if (!_formKey.currentState!
                                                  .validate()) return null;

                                              if (estimatedTime ==
                                                  "No Slots Left!") {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder: (BuildContext
                                                      dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "All the available slots are filled. Do you wish you add extra slots?",
                                                        style: GoogleFonts
                                                            .publicSans(),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                          },
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .black)),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            _scaffoldKey
                                                                .currentContext!
                                                                .loaderOverlay
                                                                .show();
                                                            addPatientExtra(
                                                                    DateTime
                                                                        .now(),
                                                                    myProfile
                                                                        .id,
                                                                    selectedSalutation +
                                                                        " " +
                                                                        widget
                                                                            .firstName,
                                                                    widget
                                                                        .lastName,
                                                                    widget.age!,
                                                                    widget
                                                                        .gender,
                                                                    widget
                                                                        .phoneNumber,
                                                                    1,
                                                                    treatment)
                                                                .then((value) {
                                                              _scaffoldKey
                                                                  .currentContext!
                                                                  .loaderOverlay
                                                                  .hide();
                                                              if (value != -1) {
                                                                print(
                                                                    "showing refresh indicator 3");
                                                                ScaffoldMessenger.of(
                                                                        _scaffoldKey
                                                                            .currentContext!)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "Patient added sucessfully"),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ));

                                                                Navigator
                                                                    .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()),
                                                                  (route) =>
                                                                      false,
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        _scaffoldKey
                                                                            .currentContext!)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "Patient could not be added due to some error"),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ));
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .black)),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                _scaffoldKey.currentContext!
                                                    .loaderOverlay
                                                    .show();
                                                addPatientMultiple(
                                                        computeSlot(
                                                            earlyResponse
                                                                .slotTime!),
                                                        DateTime.now(),
                                                        myProfile.id,
                                                        selectedSalutation +
                                                            " " +
                                                            widget.firstName,
                                                        widget.lastName,
                                                        widget.age!,
                                                        widget.gender,
                                                        widget.phoneNumber,
                                                        1,
                                                        treatment,
                                                        useTreatmentOrNot)
                                                    .then((value) {
                                                  _scaffoldKey.currentContext!
                                                      .loaderOverlay
                                                      .hide();
                                                  if (value != -1) {
                                                    print(
                                                        "showing refresh indicator");
                                                    if (widget
                                                            .refreshIndicatorKey !=
                                                        null) {
                                                      widget
                                                          .refreshIndicatorKey!
                                                          .currentState!
                                                          .show();
                                                    }
                                                    ScaffoldMessenger.of(
                                                            _scaffoldKey
                                                                .currentContext!)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Patient added sucessfully"),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ));

                                                    Navigator.of(context).pop();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            _scaffoldKey
                                                                .currentContext!)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Patient could not be added due to some error"),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ));
                                                  }
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else
                                  return SpinKitPouringHourGlass(
                                      color: Colors.grey);
                              })
                          : //early is true:
                          Column(
                              children: [
                                (!myProfile.category
                                            .toLowerCase()
                                            .contains("dentist") ||
                                        (myProfile.category
                                                .toLowerCase()
                                                .contains("dentist") &&
                                            treatment == 'Other'))
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            "Number of Slots",
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.038,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                    controller: _controller,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                      decimal: false,
                                                      signed: true,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 38.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          child: Icon(
                                                            Icons.arrow_drop_up,
                                                            size: 18.0,
                                                          ),
                                                          onTap: () {
                                                            int currentValue =
                                                                int.parse(
                                                                    _controller
                                                                        .text);
                                                            setState(() {
                                                              currentValue++;
                                                              numSlots =
                                                                  currentValue;
                                                              _controller.text =
                                                                  (currentValue)
                                                                      .toString(); // incrementing value
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          Icons.arrow_drop_down,
                                                          size: 18.0,
                                                        ),
                                                        onTap: () {
                                                          int currentValue =
                                                              int.parse(
                                                                  _controller
                                                                      .text);
                                                          setState(() {
                                                            //print("Setting state");
                                                            currentValue--;
                                                            numSlots =
                                                                currentValue > 1
                                                                    ? currentValue
                                                                    : 1;
                                                            _controller
                                                                .text = (currentValue >
                                                                        1
                                                                    ? currentValue
                                                                    : 1)
                                                                .toString(); // decrementing value
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                FutureBuilder(
                                    future: getAvailableDates,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        print(
                                            "got the future data of available dates ${myProfile.id}");
                                        // print(snapshot.data);
                                        datesAvailable =
                                            snapshot.data as List<DateTime>;

                                        if (datesAvailable.length == 0) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Center(
                                              child: Text(
                                                "No Dates Available!",
                                                style: GoogleFonts.publicSans(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (selectedDate.year == -1) {
                                            selectedDate = datesAvailable[0];
                                            getAvailSlotsFutureResponse =
                                                _getAvailSlots(
                                                    convertDateToString(
                                                        selectedDate),
                                                    myProfile.id);
                                          }
                                          return Column(
                                            children: [
                                              dateBuilder(datesAvailable),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () async {
                                                    final DateTime? date =
                                                        await showDatePicker(
                                                            selectableDayPredicate:
                                                                (day) {
                                                              if (day.compareTo(
                                                                      datesAvailable[
                                                                          datesAvailable.length -
                                                                              1]) <
                                                                  0)
                                                                return false;
                                                              else
                                                                return true;
                                                            },
                                                            context: context,
                                                            initialDate:
                                                                datesAvailable[
                                                                    datesAvailable
                                                                            .length -
                                                                        1],
                                                            firstDate: DateTime(
                                                                2015, 8),
                                                            lastDate:
                                                                DateTime(2101));

                                                    if (date != null &&
                                                        !datesAvailable
                                                            .contains(date)) {
                                                      setState(() {
                                                        datesAvailable
                                                            .add(date);
                                                        datesAvailable.sort();
                                                        selectedDate = date;
                                                        marked = datesAvailable
                                                            .indexOf(date);
                                                        scrollToItem(marked);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF000000)
                                                          .withOpacity(0.04),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_sharp,
                                                      color: Colors.black,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              FutureBuilder(
                                                  future:
                                                      getAvailSlotsFutureResponse,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                      List<
                                                              List<
                                                                  Tuple2<
                                                                      TimeOfDay,
                                                                      bool>>>
                                                          batchWiseSlots =
                                                          snapshot.data as List<
                                                              List<
                                                                  Tuple2<
                                                                      TimeOfDay,
                                                                      bool>>>;

                                                      if (batchWiseSlots
                                                              .length ==
                                                          0)
                                                        return Center(
                                                            child: Text(
                                                          "No slots available for today!",
                                                          style: GoogleFonts
                                                              .publicSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14),
                                                        ));

                                                      return SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            for (int i = 0;
                                                                i <
                                                                    batchWiseSlots
                                                                        .length;
                                                                i++)
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  i == 0
                                                                      ? Text(
                                                                          "Morning Slots",
                                                                          style: GoogleFonts.publicSans(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14),
                                                                        )
                                                                      : i == 1
                                                                          ? Text(
                                                                              "Afternoon Slots",
                                                                              style: GoogleFonts.publicSans(fontWeight: FontWeight.w600, fontSize: 14),
                                                                            )
                                                                          : Text(
                                                                              "Evening Slots",
                                                                              style: GoogleFonts.publicSans(fontWeight: FontWeight.w600, fontSize: 14),
                                                                            ),
                                                                  GridView
                                                                      .builder(
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return slot(
                                                                          batchWiseSlots[i]
                                                                              .elementAt(
                                                                                  index)
                                                                              .item1,
                                                                          batchWiseSlots[i]
                                                                              .elementAt(index)
                                                                              .item2,
                                                                          index,
                                                                          i,
                                                                          convertDateToString(selectedDate));
                                                                    },
                                                                    itemCount:
                                                                        batchWiseSlots[i]
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            4,
                                                                        mainAxisExtent:
                                                                            65),
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    physics:
                                                                        AlwaysScrollableScrollPhysics(),
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        width: double.infinity,
                                                        child: Center(
                                                            child:
                                                                SpinKitChasingDots(
                                                          color: Colors.grey,
                                                        )),
                                                      );
                                                    } else
                                                      return Container(
                                                        width: double.infinity,
                                                        child: Center(
                                                            child:
                                                                SpinKitChasingDots(
                                                          color: Colors.grey,
                                                        )),
                                                      );
                                                  })
                                            ],
                                          );
                                        }
                                      } else
                                        return Container(
                                          width: double.infinity,
                                          child: Center(
                                              child: SpinKitChasingDots(
                                            color: Colors.grey,
                                          )),
                                        );
                                    }),
                              ],
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Divider(
                        thickness: 0.6,
                        color: Color.fromARGB(255, 234, 234, 234),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future scrollToItem(index) async {
    itemController.scrollTo(index: index, duration: Duration(seconds: 1));
  }

  Widget dateBuilder(List<DateTime> days) {
    print("Date builder getting called");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: getProportionateScreenHeight(0.14 * 812),
        child: ScrollablePositionedList.builder(
            itemScrollController: itemController,
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      marked = index;
                      selectedDate = days[index];
                      getAvailSlotsFutureResponse = _getAvailSlots(
                          convertDateToString(selectedDate), myProfile.id);
                    });
                  },
                  child: SizedBox(
                    width: getProportionateScreenWidth(0.12 * 375),
                    height: getProportionateScreenHeight(0.14 * 812),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: getProportionateScreenWidth(0.12 * 375),
                            height: getProportionateScreenHeight(0.03 * 812),
                            decoration: BoxDecoration(
                              color:
                                  marked == index ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            )),
                        Container(
                          height: getProportionateScreenHeight(0.08 * 812),
                          width: getProportionateScreenWidth(0.12 * 375),
                          color: marked == index ? Colors.black : Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  DateFormat("EEEE")
                                      .format(days[index])
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
                              Text(days[index].day.toString(),
                                  style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: marked == index
                                          ? Colors.white
                                          : Colors.black)),
                              Text(DateFormat("MMM").format(days[index]),
                                  style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: marked == index
                                          ? Colors.white
                                          : Colors.black)),
                            ],
                          ),
                        ),
                        Container(
                            width: getProportionateScreenWidth(0.12 * 375),
                            height: getProportionateScreenHeight(0.03 * 812),
                            decoration: BoxDecoration(
                              color:
                                  marked == index ? Colors.black : Colors.white,
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
    );
  }

  Widget slot(TimeOfDay selectedSlot, bool avail, int index, int batchNo,
      String selectedDay) {
    return InkWell(
      onTap: () {
        if (avail == false) return;
        showModalBottomSheet(
            context: context,
            builder: (bottomSheetcontext) {
              print("buttom modal sheet is opened with avail = $avail");
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print("add patient is tapped");
                      print(_formKey.currentState!.validate());
                      if (_formKey.currentState!.validate()) {
                        return showDialog<void>(
                          context: _scaffoldKey.currentContext!,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text(
                                "Do you want to confirm this booking?",
                                style: GoogleFonts.publicSans(),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(dialogContext).pop();
                                    // String result =
                                    //     await cancelAppointment(bookingId);
                                    // if (result == "Success") {
                                    //   showDialog<void>(
                                    //     context: context,
                                    //     barrierDismissible:
                                    //         false, // user must tap button!
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: const Text(
                                    //             'Appointment Cancelled Successfully'),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             child: const Text('OK'),
                                    //             onPressed: () {
                                    //               Navigator.push(
                                    //                   context,
                                    //                   MaterialPageRoute(
                                    //                       builder: (context) =>
                                    //                           HomeScreen()));
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.firstName = selectedSalutation +
                                        " " +
                                        widget.firstName;

                                    print("add patient button is clicked");
                                    print(
                                        "treatment inside bottom modal sheet is $treatment");
                                    if (avail == false) return null;
                                    Navigator.of(dialogContext).pop();
                                    FocusScopeNode currentFocus = FocusScope.of(
                                        _scaffoldKey.currentContext!);
                                    currentFocus.unfocus();
                                    Navigator.pop(_scaffoldKey.currentContext!);
                                    _scaffoldKey.currentContext!.loaderOverlay
                                        .show();
                                    addPatientMultiple(
                                            selectedSlot,
                                            selectedDate,
                                            myProfile.id,
                                            selectedSalutation +
                                                " " +
                                                widget.firstName,
                                            widget.lastName,
                                            widget.age!,
                                            widget.gender,
                                            widget.phoneNumber,
                                            numSlots,
                                            treatment,
                                            useTreatmentOrNot)
                                        .then((value) {
                                      _scaffoldKey.currentContext!.loaderOverlay
                                          .hide();
                                      if (value != -1) {
                                        if (widget.refreshIndicatorKey !=
                                            null) {
                                          widget.refreshIndicatorKey!
                                              .currentState!
                                              .show();
                                        }
                                        ScaffoldMessenger.of(
                                                _scaffoldKey.currentContext!)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Patient added sucessfully"),
                                          duration: Duration(seconds: 2),
                                        ));
                                        Navigator.of(context).pop();
                                      } else {
                                        print(
                                            "printing scaffold patient could not be added due to some error");
                                        ScaffoldMessenger.of(
                                                _scaffoldKey.currentContext!)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Patient could not be added due to some error"),
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    });
                                  },
                                  child: Text("Confirm",
                                      style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black)),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        print("popping context");
                        Navigator.pop(bottomSheetcontext);
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }
                    },
                    child: Container(
                      width: SizeConfig.screenWidth * 0.84,
                      height: SizeConfig.screenHeight * 0.06,
                      color: Colors.black,
                      child: Center(
                          child: Text(
                        "Add Patient",
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
              );
            });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(color: avail ? Colors.black : Colors.white),
            color: avail ? Colors.white : Color(0xFFF3F3F3)),
        // color: avail
        //     ?  Color(0xF3F3F3)
        //     : Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Center(
          child: Text(
            selectedSlot.format(context),
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: avail ? Colors.black : Color(0xFF7A7A7A)),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "First Name",
          style: headingStyle,
        ),
        Row(
          children: [
            Flexible(
              flex: 17,
              // width: getProportionateScreenWidth(45),
              child: DropdownButtonFormField<String>(
                decoration: inputDecoration,
                value: selectedSalutation,
                hint: Text(
                  salutationsList[0],
                  style: inputStyle,
                ),
                onChanged: (salutation) =>
                    setState(() => selectedSalutation = salutation!),
                validator: (value) => value == null ? 'field required' : null,
                items: salutationsList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: inputStyle,
                    ),
                  );
                }).toList(),
              ),
            ),
            Flexible(
              flex: 90,
              child: TextFormField(
                initialValue: widget.firstName,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter the first Name";
                  else
                    return null;
                },
                style: inputStyle,
                decoration: inputDecoration,
                onChanged: (value) {
                  setState(() {
                    widget.firstName = value;
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLastName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Name",
          style: headingStyle,
        ),
        TextFormField(
          initialValue: widget.lastName,
          style: inputStyle,
          decoration: inputDecoration,
          onChanged: (value) {
            setState(() {
              widget.lastName = value;
            });
          },
        )
      ],
    );
  }

  Widget _buildMobileNo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile No.",
          style: headingStyle,
        ),
        TextFormField(
          controller: c,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (value) {
            if (value == null || value.isEmpty || value.length != 10)
              return "Please enter correct phone number";
            else
              return null;
          },
          style: inputStyle,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              counter: Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: Text(
                  c.value.text.length.toString() + "/10",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: c.text.length != 10
                          ? Color.fromARGB(255, 158, 158, 158)
                          : Colors.green),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, style: BorderStyle.solid)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, style: BorderStyle.solid)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, style: BorderStyle.solid))),
          onChanged: (value) {
            setState(() {
              // print("On changed method called where value is $value");
              if (value.length == 10)
                FocusManager.instance.primaryFocus!.unfocus();
              widget.phoneNumber = value;
            });
          },
        )
      ],
    );
  }

  Widget _buildAge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Age",
          style: headingStyle,
        ),
        TextFormField(
          initialValue: (widget.age == null || widget.age == -1)
              ? ""
              : widget.age.toString(),
          validator: (value) {
            if (value == null || value.isEmpty)
              return "Please enter the age";
            else
              return null;
          },
          keyboardType: TextInputType.number,
          style: inputStyle,
          decoration: inputDecoration,
          onChanged: (value) {
            setState(() {
              widget.age = int.parse(value);
            });
          },
        )
      ],
    );
  }

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
                //print(value);
                select = value.toString();
                widget.gender = value.toString();
              });
            },
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildTreatment() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Treatment",
        style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
      ),
      DropdownButton<String>(
          value: treatment,
          items: docTreatmentsAvailable.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              treatment = value!;
              debugPrint("Treatment selected is $treatment");
            });
          })
    ]);
  }

  Future<int> addPatientExtra(
      DateTime dateToBeUsed,
      int docId,
      String firstName,
      String lastName,
      int age,
      String gender,
      String phoneNumber,
      int batchNumber,
      String treatment) async {
    print("Extra patient api is called");
    String formattedDate = dateToBeUsed.day.toString().padLeft(2, "0") +
        "-" +
        dateToBeUsed.month.toString().padLeft(2, "0") +
        "-" +
        dateToBeUsed.year.toString();
    debugPrint("Date:" + formattedDate);

    final response = await http.post(
      Uri.parse(addBookingExtra),
      headers: header,
      body: jsonEncode(<String, dynamic>{
        "Patients": {
          "first_name": firstName,
          "last_name": lastName,
          "age": age,
          "gender": gender,
          "phone_number": phoneNumber
        },
        "doc_id": docId,
        "date": formattedDate,
        "treatment": treatment
      }),
    );
    print(jsonEncode(<String, dynamic>{
      "Patients": {
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "gender": gender,
        "phone_number": phoneNumber
      },
      "doc_id": docId,
      "date": formattedDate,
      "treatment": treatment
    }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      BookingResponse bookingResponse = BookingResponse.fromJson(jsonResponse);
      debugPrint(bookingResponse.bookingId.toString());

      return bookingResponse.bookingId;
    } else {
      return -1;
    }
  }

// Future<int> addPatient(
//     TimeOfDay time,
//     DateTime dateToBeUsed,
//     int docId,
//     String firstName,
//     String lastName,
//     int age,
//     String gender,
//     String phoneNumber,
//     String treatment,
//     bool specOrNot) async {
//   String formattedDate = dateToBeUsed.day.toString().padLeft(2, "0") +
//       "-" +
//       dateToBeUsed.month.toString().padLeft(2, "0") +
//       "-" +
//       dateToBeUsed.year.toString();
//   debugPrint("Date:" + formattedDate);
//   String hour = time.hour.toString().padLeft(2, "0"),
//       minute = time.minute.toString().padLeft(2, "0");
//   String finalTime = hour + minute;
//   int startTime = int.parse(finalTime);
//   debugPrint("Time:" + finalTime);
//   treatment = specOrNot ? treatment : "";
//   final response = await http.post(
//     Uri.parse(addBooking),
//     headers: header,
//     body: jsonEncode(<String, dynamic>{
//       "Patients": {
//         "first_name": firstName,
//         "last_name": lastName,
//         "age": age,
//         "gender": gender,
//         "phone_number": phoneNumber
//       },
//       "doc_id": docId,
//       "slot_time": startTime,
//       "date": formattedDate,
//       "treatment": treatment
//     }),
//   );

//   print(response.statusCode);
//   //print(metaData.password);
//   //print(myProfile.phoneNumber);
//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     BookingResponse bookingResponse = BookingResponse.fromJson(jsonResponse);
//     debugPrint(bookingResponse.bookingId.toString());
//     return bookingResponse.bookingId;
//   } else {
//     return null;
//   }
// }

  Future<int> addPatientMultiple(
      TimeOfDay time,
      DateTime dateToBeUsed,
      int docId,
      String firstName,
      String lastName,
      int age,
      String gender,
      String phoneNumber,
      int numSlots,
      String treatment,
      bool useSpecOrNot) async {
    String formattedDate = dateToBeUsed.day.toString().padLeft(2, "0") +
        "-" +
        dateToBeUsed.month.toString().padLeft(2, "0") +
        "-" +
        dateToBeUsed.year.toString();
    debugPrint("Date:" + formattedDate);
    String hour = time.hour.toString().padLeft(2, "0"),
        minute = time.minute.toString().padLeft(2, "0");
    String finalTime = hour + minute;
    int startTime = int.parse(finalTime);
    debugPrint("Time:" + finalTime);

    print("add patient function is called");
    var body = jsonEncode(<String, dynamic>{
      "Patients": {
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "gender": gender,
        "phone_number": phoneNumber
      },
      "doc_id": docId,
      "slot_time": startTime,
      "num_slots": numSlots == 1 ? null : numSlots,
      "date": formattedDate,
      "treatment": treatment
    });
    print(body);
    final response =
        await http.post(Uri.parse(addBooking), headers: header, body: body);
    debugPrint(body);
    print("....................");
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      BookingResponse bookingResponse = BookingResponse.fromJson(jsonResponse);
      debugPrint(bookingResponse.bookingId.toString());
      return bookingResponse.bookingId;
    } else {
      return -1;
    }
  }
}

//this future is called too many times. this should be optimzed
Future<List<DateTime>> _getAvailDates(int docId) async {
  var response = await http.post(Uri.parse(getAvailDates),
      body: jsonEncode(<String, int>{
        "doc_id": docId,
      }),
      headers: header);
  //print("Response Recieved for Dates");
  if (response.statusCode == 200) {
    List<DateTime> datesList = [];
    var jsonResponse = jsonDecode(response.body);
    print("Dates recieved for id $docId");
    print(jsonResponse);
    (jsonResponse["dates"] as List).forEach((d) {
      DateTime date = computeDate(d);
      datesList.add(date);
    });
    return datesList;
  } else
    return [];
}

Future<EarlyResponse> getEarliestSlot(int docId) async {
  print("Fetching earliest slot");
  final response = await http.post(
    Uri.parse(getEarlyUrl),
    headers: header,
    body: jsonEncode(<String, int>{"doc_id": docId}),
  );
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    EarlyResponse earlyResponse = EarlyResponse.fromJson(jsonResponse);
    debugPrint(earlyResponse.slotTime.toString() + "slotTime");
    return earlyResponse;
  } else {
    return EarlyResponse(estTime: "", slotTime: -1);
  }
}

class EarlyResponse {
  EarlyResponse({
    required this.slotTime,
    required this.estTime,
  });

  int? slotTime;
  String? estTime;

  factory EarlyResponse.fromJson(Map<String, dynamic> parsedJson) {
    return EarlyResponse(
        slotTime: parsedJson['slot_time'] ?? -1,
        estTime: parsedJson["est_time"] ?? "");
  }
}

class BookingResponse {
  int bookingId;
  BookingResponse({required this.bookingId});

  factory BookingResponse.fromJson(Map<String, dynamic> parsedJson) {
    return BookingResponse(bookingId: parsedJson['booking_id']);
  }
}

Future<List<List<Tuple2<TimeOfDay, bool>>>> _getAvailSlots(
    String date, int docId) async {
  var response = await http.post(Uri.parse(getAvailSlotsUrl),
      body: jsonEncode(<String, dynamic>{"doc_id": docId, "date": date}),
      headers: header);
  //print("Response Recieved for Slots with status code ${response.statusCode}");

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print("slots response is $jsonResponse");
    SlotResponse slotResponse = new SlotResponse.fromJson(jsonResponse);
    // print(slotResponse.batches[0].slotTime.toList());
    List<Batches> batchList = slotResponse.batches;
    List<List<Tuple2<TimeOfDay, bool>>> batchWiseSlots =
        List.generate(batchList.length, (index) => []);

    for (int i = 0; i < batchList.length; i++) {
      int numberOfSlots = batchList[i].slotTime.length;
      for (int j = 0; j < numberOfSlots; j++) {
        batchWiseSlots[i].add(Tuple2<TimeOfDay, bool>(
            computeSlot(int.parse(batchList[i].slotTime[j])),
            batchList[i].availability[j]));
      }
    }

    return batchWiseSlots;
  } else
    return [];
}

class SlotResponse {
  late List<Batches> batches;

  SlotResponse({required this.batches});

  SlotResponse.fromJson(Map<String, dynamic> json) {
    if (json['batches'] != null) {
      batches = <Batches>[];
      json['batches'].forEach((v) {
        batches.add(new Batches.fromJson(v));
      });
    }
  }
}

class Batches {
  late List<String> slotTime;
  late List<bool> availability;

  Batches({required this.slotTime, required this.availability});

  Batches.fromJson(Map<String, dynamic> json) {
    if (json['slot_time'] != null) {
      slotTime = <String>[];
      json['slot_time'].forEach((v) {
        slotTime.add(v.toString());
      });
    }
    if (json['availability'] != null) {
      availability = <bool>[];
      json['availability'].forEach((v) {
        int b = v;
        bool t;
        b == 0 ? t = false : t = true;
        availability.add(t);
      });
    }
  }
}

DateTime computeDate(String d) {
  List<String> strings = d.toString().split("-");
  int year = int.parse(strings[2]);
  int month = int.parse(strings[1]);
  int day = int.parse(strings[0]);
  DateTime date = DateTime(year, month, day);
  return date;
}

TimeOfDay computeSlot(int d) {
  int minutes = d % 100;
  int hours = (d / 100).floor();
  TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
  return slot;
}

String convertDateToString(DateTime date) {
  return date.day.toString().padLeft(2, "0") +
      "-" +
      date.month.toString().padLeft(2, "0") +
      "-" +
      date.year.toString();
}

Future<bool> getSpecialization() async {
  prefs = await SharedPreferences.getInstance();
  String spec = prefs.getString("specialization") ?? myProfile.specialization;
  //print("specialization is $spec");
  if (spec.contains("Dentist") || spec.contains("dentist"))
    return true;
  else
    return false;
}
