import 'dart:io';
import 'package:doctor/Models/Appointment.dart';
import 'package:doctor/Models/DoctorModel.dart';
import 'package:doctor/Models/PatientModel.dart';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/providers/appointmentProvider.dart';
import 'package:doctor/screens/homeScreen/components/CurrentPatient.dart';
import 'package:doctor/screens/homeScreen/components/bookingListCard.dart';
import 'package:doctor/screens/homeScreen/components/currPatientForTwo.dart';
import 'package:doctor/screens/loginScreen/components/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../Models/DoctorBookings.dart';
import '../../../components/urls.dart';
import '../../addPatientScreen/AddPatientScreen.dart';
import 'ReachedListCard.dart';
import 'accountsScreen.dart';
import 'reachedListCardForTwo.dart';
import 'requests.dart';

class HomeScreenBody extends StatefulWidget {
  HomeScreenBody({Key? key}) : super(key: key);
  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late Future<String> getReachedQueueFutureResponse,
      getBookingQueueFutureResponse;
  late Future<DoctorModel> getDocInfoFutureResponse;
  int pageIndex = 0;
  late TimeOfDay timePicked;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dummyPat =
          List.generate(8, (index) => dummyPatForSkeleton, growable: true),
      dummyBooking =
          List.generate(8, (index) => dummyBookingForSkeleton, growable: true);

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    initializeHeader();
    getDocInfoFutureResponse = getDocInfo(myProfile.id);
    onRefresh();
  }

  void onRefresh() async {
    setState(() {
      getReachedQueueFutureResponse = getReachedQueue(myProfile.id, context);
      getBookingQueueFutureResponse = getBookingQueue(myProfile.id, context);
    });
  }

  void refreshReached() async {
    setState(() {
      getReachedQueueFutureResponse = getReachedQueue(myProfile.id, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    int id = prefs.getInt("currentDocId") ?? -1;
    myProfile.id = id;
    int patPerSlot = prefs.getInt("pat_per_slot") ?? 0;

    return LoaderOverlay(
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
                "INCUE",
                style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 20),
              ),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountsScreen(
                                refreshIndicatorKey: refreshIndicatorKey,
                              )));
                },
                child: Transform.translate(
                    offset: Offset(14, 0),
                    child: Container(
                      margin: EdgeInsets.all(14),
                      height: 32,
                      width: 32,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    TimeOfDay? picked = (kIsWeb || Platform.isAndroid)
                        ? await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 0, minute: 15),
                            initialEntryMode: TimePickerEntryMode.input,
                            builder: (context, childWidget) {
                              return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      // Using 24-Hour format
                                      alwaysUse24HourFormat: true),
                                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false o
                                  //remove all the builder argument
                                  child: childWidget!);
                            },
                          )
                        : await showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                                  height: 500,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 400,
                                        child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.time,
                                            use24hFormat: true,
                                            initialDateTime: DateTime.now(),
                                            onDateTimeChanged: (val) {}),
                                      ),
                                      // Close the modal
                                      CupertinoButton(
                                        child: const Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ),
                                ));

                    print("time picked for delay ");
                    print(picked);
                    if (picked == null) {
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => WillPopScope(
                                  onWillPop: _onWillPop,
                                  child: SpinKitPouringHourGlass(
                                    color: Colors.grey,
                                  ),
                                )),
                      );
                    }
                    var result = await addDelay(myProfile.id, picked!);
                    print("after future");
                    print(result);
                    Navigator.pop(context);
                    if (result != "Success")
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        content: Text(
                            "There was some error and delay could not be added"),
                      ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Icon(
                          Icons.more_time_sharp,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPatientScreen(
                        age: null,
                        firstName: "",
                        gender: "",
                        lastName: "",
                        phoneNumber: "",
                        treatment: "",
                        getEarly: true,
                        refreshIndicatorKey: refreshIndicatorKey,
                      ),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Icon(
                          Icons.person_add_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Consumer<AppointmentProvider>(
                builder: (context, appointmentProvider, _) => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 0.04,
                          vertical: 16),
                      child: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                        strokeWidth: 3.0,
                        key: refreshIndicatorKey,
                        // This check is used to customize listening to scroll notifications
                        // from the widget's children.
                        notificationPredicate:
                            (ScrollNotification notification) {
                          return notification.depth == 1 ||
                              notification.depth == 0;
                        },
                        onRefresh: () async {
                          setState(() {
                            getBookingQueueFutureResponse =
                                getBookingQueue(myProfile.id, context);
                            getReachedQueueFutureResponse =
                                getReachedQueue(myProfile.id, context);
                          });
                        },
                        child: FutureBuilder(
                            future: getDocInfoFutureResponse,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.data == null)
                                  return SpinKitPouringHourGlass(
                                      color: Colors.grey);

                                myProfile = snapshot.data as DoctorModel;
                                patPerSlot = myProfile.patPerSlot;
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      myNavBar(context),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      pageIndex == 0
                                          ? Expanded(
                                              child: FutureBuilder(
                                                future:
                                                    getReachedQueueFutureResponse,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                    bool hasData = false;
                                                    List<Appointment> reached =
                                                            appointmentProvider
                                                                .getReachedAppoin,
                                                        curr =
                                                            appointmentProvider
                                                                .getCurrAppoin;

                                                    List<PatientModel>
                                                        patListReached = [];
                                                    List<DoctorBookingsModel>
                                                        bookListReached = [];
                                                    List<PatientModel>
                                                        currentPatients = [];
                                                    List<DoctorBookingsModel>
                                                        currentPatientBookings =
                                                        [];
                                                    List<int> timeLeft = [];

                                                    reached.forEach((element) {
                                                      patListReached.add(
                                                          element.patientModel);
                                                      bookListReached.add(element
                                                          .doctorBookingsModel);
                                                      timeLeft.add(
                                                          element.timeLeft ??
                                                              0);
                                                    });

                                                    curr.forEach((element) {
                                                      currentPatients.add(
                                                          element.patientModel);
                                                      currentPatientBookings
                                                          .add(element
                                                              .doctorBookingsModel);
                                                    });

                                                    int numCurrentPatient =
                                                        currentPatients.length;

                                                    if (patListReached.length >
                                                        0) {
                                                      hasData = true;
                                                    }

                                                    return SingleChildScrollView(
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        child: patPerSlot == 1
                                                            ? Column(
                                                                children: [
                                                                  numCurrentPatient ==
                                                                          1
                                                                      ? currentPatient(
                                                                          currentPatientBookings[
                                                                              0],
                                                                          currentPatients[
                                                                              0],
                                                                          context,
                                                                          refreshIndicatorKey,
                                                                          _scaffoldKey)
                                                                      : SizedBox(
                                                                          height:
                                                                              0,
                                                                        ),
                                                                  (hasData == true ||
                                                                          numCurrentPatient ==
                                                                              1)
                                                                      ? ListView.builder(
                                                                          shrinkWrap: true,
                                                                          physics: AlwaysScrollableScrollPhysics(),
                                                                          itemCount: patListReached.length,
                                                                          itemBuilder: (context, index) {
                                                                            return ReachedListCard(
                                                                                patListReached[index],
                                                                                bookListReached[index],
                                                                                refreshIndicatorKey,
                                                                                timeLeft[index],
                                                                                currentPatientBookings.length > 0 ? currentPatientBookings[0].bookingId : 0,
                                                                                _scaffoldKey,
                                                                                onRefresh);
                                                                          })
                                                                      : (Center(
                                                                          child:
                                                                              Column(
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
                                                                                "No patients Reached!",
                                                                                style: GoogleFonts.publicSans(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                ],
                                                              )
                                                            : Column(
                                                                children: [
                                                                  numCurrentPatient >=
                                                                          1
                                                                      ? IntrinsicHeight(
                                                                          child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                              children: [
                                                                                CurrentPatientForTwo(currentPatientBookings[0], currentPatients[0], bookListReached, patListReached, refreshIndicatorKey, 1, _scaffoldKey),
                                                                              ]),
                                                                        )
                                                                      : SizedBox(
                                                                          height:
                                                                              0,
                                                                        ),
                                                                  numCurrentPatient ==
                                                                          2
                                                                      ? IntrinsicHeight(
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.stretch,
                                                                            children: [
                                                                              CurrentPatientForTwo(currentPatientBookings[1], currentPatients[1], bookListReached, patListReached, refreshIndicatorKey, 2, _scaffoldKey),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : SizedBox(
                                                                          height:
                                                                              0,
                                                                        ),
                                                                  hasData ==
                                                                          true
                                                                      ? ListView.builder(
                                                                          shrinkWrap: true,
                                                                          physics: AlwaysScrollableScrollPhysics(),
                                                                          itemCount: patListReached.length,
                                                                          itemBuilder: (context, index) {
                                                                            return ReachedListCardForTwo(
                                                                                patListReached[index], //this part can be optimized.
                                                                                bookListReached[index],
                                                                                refreshIndicatorKey,
                                                                                timeLeft[index],
                                                                                numCurrentPatient == 1 ? Appointment(doctorBookingsModel: currentPatientBookings[0], patientModel: currentPatients[0]) : Appointment(doctorBookingsModel: DoctorBookingsModel(date: "", startTime: '', slotTime: "", endTime: "", docId: -1, patId: -1, batchNumber: -1, slotNumber: -1, bookingId: -1, treatment: "", consentForm: false, balance: 0, notes: "", installment: 0), patientModel: PatientModel(id: -1, email: "", gender: "", firstName: "", lastName: "", city: "", age: -1, phoneNumber: "")),
                                                                                numCurrentPatient == 2 ? Appointment(doctorBookingsModel: currentPatientBookings[1], patientModel: currentPatients[1]) : Appointment(doctorBookingsModel: DoctorBookingsModel(date: "", startTime: '', slotTime: "", endTime: "", docId: -1, patId: -1, batchNumber: -1, slotNumber: -1, bookingId: -1, treatment: "", consentForm: false, balance: 0, notes: "", installment: 0), patientModel: PatientModel(id: -1, email: "", gender: "", firstName: "", lastName: "", city: "", age: -1, phoneNumber: "")),
                                                                                _scaffoldKey,
                                                                                onRefresh);
                                                                          })
                                                                      : (numCurrentPatient == 0)
                                                                          ? (Center(
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: getProportionateScreenHeight(60),
                                                                                  ),
                                                                                  Image.asset(
                                                                                    "assets/images/nopat.png",
                                                                                    width: getProportionateScreenWidth(150),
                                                                                    height: getProportionateScreenHeight(150),
                                                                                  ),
                                                                                  Text(
                                                                                    "No patients Reached!",
                                                                                    style: GoogleFonts.publicSans(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                          : SizedBox(height: 0)
                                                                ],
                                                              ));
                                                  }
                                                  return Skeletonizer(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        itemCount:
                                                            dummyPat.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ReachedListCardForTwo(
                                                              dummyPat[
                                                                  index], //this part can be optimized.
                                                              dummyBookingForSkeleton,
                                                              refreshIndicatorKey,
                                                              0,
                                                              Appointment(
                                                                  doctorBookingsModel:
                                                                      dummyBookingForSkeleton,
                                                                  patientModel:
                                                                      dummyPatForSkeleton),
                                                              Appointment(
                                                                  doctorBookingsModel:
                                                                      dummyBookingForSkeleton,
                                                                  patientModel:
                                                                      dummyPatForSkeleton),
                                                              _scaffoldKey,
                                                              onRefresh);
                                                        }),
                                                  );
                                                },
                                              ),
                                            )
                                          : Expanded(
                                              child: FutureBuilder(
                                                future:
                                                    getBookingQueueFutureResponse,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                    bool hasData = false;
                                                    List<Appointment> bookings =
                                                        appointmentProvider
                                                            .getBookAppoin;
                                                    List<PatientModel>
                                                        bookingPatList = [];
                                                    List<DoctorBookingsModel>
                                                        bookingBookList = [];

                                                    bookings.forEach((element) {
                                                      bookingPatList.add(
                                                          element.patientModel);
                                                      bookingBookList.add(element
                                                          .doctorBookingsModel);
                                                    });

                                                    if (bookingPatList.length >
                                                        0) {
                                                      hasData = true;
                                                    }
                                                    debugPrint(bookingPatList
                                                        .length
                                                        .toString());
                                                    return SingleChildScrollView(
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        child: hasData == true
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    AlwaysScrollableScrollPhysics(),
                                                                itemCount:
                                                                    bookingPatList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return BookingListCard(
                                                                      bookingPatList[
                                                                          index],
                                                                      bookingBookList[
                                                                          index],
                                                                      context,
                                                                      refreshIndicatorKey,
                                                                      _scaffoldKey,
                                                                      refreshReached);
                                                                })
                                                            : Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          60,
                                                                    ),
                                                                    Image.asset(
                                                                      "assets/images/nobook.png",
                                                                      width:
                                                                          113,
                                                                      height:
                                                                          113,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "No bookings yet for today!",
                                                                      style: GoogleFonts.publicSans(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                  }
                                                  return Skeletonizer(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        itemCount:
                                                            dummyBooking.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return BookingListCard(
                                                              dummyPat[index],
                                                              dummyBooking[
                                                                  index],
                                                              context,
                                                              refreshIndicatorKey,
                                                              _scaffoldKey,
                                                              refreshReached);
                                                        }),
                                                  );
                                                },
                                              ),
                                            ),
                                    ]);
                              } else
                                return SpinKitPouringHourGlass(
                                    color: Colors.grey);
                            }),
                      ),
                    ))));
  }

  Container myNavBar(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 246, 246, 246),
            ),
            color: Color.fromARGB(255, 246, 246, 246),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.015, top: 3, bottom: 3),
                child: Container(
                  width: SizeConfig.screenWidth * 0.43,
                  decoration: BoxDecoration(
                    color: pageIndex == 0
                        ? Colors.black
                        : Color.fromARGB(255, 246, 246, 246),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TextButton(
                    onPressed: () => {
                      setState(() {
                        pageIndex = 0;
                      })
                    },
                    child: Text(
                      "Reached",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: pageIndex == 0
                              ? Colors.white
                              : Color.fromARGB(255, 154, 154, 154),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: VerticalDivider(
                  thickness: 2,
                  width: SizeConfig.screenWidth * 0.02,
                  color: Color.fromARGB(255, 234, 234, 234),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: SizeConfig.screenWidth * 0.015, top: 3, bottom: 3),
                child: Container(
                  width: SizeConfig.screenWidth * 0.43,
                  decoration: BoxDecoration(
                    color: pageIndex == 1
                        ? Colors.black
                        : Color.fromARGB(255, 246, 246, 246),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TextButton(
                    onPressed: () => {
                      setState(() {
                        pageIndex = 1;
                      })
                    },
                    child: Text(
                      "Bookings",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: pageIndex == 1
                              ? Colors.white
                              : Color.fromARGB(255, 154, 154, 154),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
