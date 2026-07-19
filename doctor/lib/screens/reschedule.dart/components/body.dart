import 'dart:convert';

import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/reschedule.dart/components/addSchedule.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../Models/DoctorReschedule.dart';
import '../../../providers/httpClientProvider.dart';

class RescheduleBody extends StatefulWidget {
  @override
  State<RescheduleBody> createState() => _RescheduleBodyState();
}

class _RescheduleBodyState extends State<RescheduleBody> {
  final TextStyle headingStyle =
      GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.bold);

  Widget card(DateTime date, List<TimeOfDay> startTimes,
      List<TimeOfDay> endTimes, List<List<int>> timingList) {
    List<String> _startTimes = [], _endTimes = [];
    for (int i = 0; i < startTimes.length; i++) {
      if (startTimes[i].hour == 0 && startTimes[i].minute == 0) {
      } else {
        _startTimes.add(timeToString(startTimes[i]));
      }
    }
    for (int i = 0; i < endTimes.length; i++) {
      if (endTimes[i].hour == 0 && endTimes[i].minute == 0) {
      } else {
        _endTimes.add(timeToString(endTimes[i]));
      }
    }
    return Container(
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
            child: ListTile(
              title: Text(
                DateFormat("EEEE").format(date).substring(0, 3) +
                    " " +
                    date.day.toString() +
                    ", " +
                    DateFormat.MMMM().format(date),
                style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: getProportionateScreenHeight(18)),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(4)),
                child: SizedBox(
                  height: getProportionateScreenHeight(20),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: getProportionateScreenHeight(20),
                        child: FittedBox(
                          child: Text(
                            computeSlot(_startTimes[index]).format(context) +
                                " - " +
                                computeSlot(_endTimes[index]).format(context) +
                                (index == _startTimes.length - 1 ? "" : ", "),
                            style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 107, 107, 107),
                                fontSize: getProportionateScreenHeight(18)),
                          ),
                        ),
                      );
                    },
                    itemCount: _startTimes.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              trailing: ClipOval(
                child: Material(
                  color: Color.fromARGB(255, 255, 74, 74),
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Are you sure you want to Delete this Rescheduled Timing?",
                              style: headingStyle,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    String deleteResp = await deleteResch(
                                        myProfile.id,
                                        dateToString(date),
                                        timingList);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(deleteResp)));
                                    f();
                                  },
                                  child: Text(
                                    "Yes",
                                    style: headingStyle,
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: headingStyle,
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: SizedBox(
                        width: 31,
                        height: 31,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 14,
                        )),
                  ),
                ),
              ),
            )));
  }

  RefreshController _refreshReschedule =
      RefreshController(initialRefresh: true);

  void f() {
    setState(() {
      _refreshReschedule.refreshCompleted();
    });
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
      floatingActionButton: InkWell(
        onTap: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSchedule(refresh: f)));
        },
        child: Container(
          width: 61,
          height: 61,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4.95),
              border: Border.all(width: 1, color: Colors.black)),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshReschedule,
        onRefresh: () {
          f();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
                future: getResch(myProfile.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, List> map = snapshot.data as Map<String, List>;
                    List<DoctorRescheduleModel> upList =
                        map["up"] as List<DoctorRescheduleModel>;
                    List<DoctorRescheduleModel> pastList =
                        map["past"] as List<DoctorRescheduleModel>;
                    if (upList.length == 0 && pastList.length == 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/noresch.png"),
                          SizedBox(
                            height: 6,
                          ),
                          Text("No Rescheduled Clinic Timings \nadded",
                              style: GoogleFonts.publicSans(
                                  fontWeight: FontWeight.w500, fontSize: 18))
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 27,
                          ),
                          upList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "Upcoming",
                                    style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                )
                              : SizedBox(height: 0),
                          SizedBox(
                            height: upList.length != 0 ? 22 : 0,
                          ),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              List<List<int>> timingList = upList[index].timing;
                              List<TimeOfDay> startTimes = [], endTimes = [];
                              for (int i = 0; i < timingList.length; i++) {
                                startTimes.add(
                                    computeSlot(timingList[i][0].toString()));
                                endTimes.add(
                                    computeSlot(timingList[i][1].toString()));
                              }
                              return card(computeDate(upList[index].date),
                                  startTimes, endTimes, timingList);
                            },
                            itemCount: upList.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                          ),
                          SizedBox(
                            height: upList.isNotEmpty ? 27 : 0,
                          ),
                          pastList.length != 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "Past",
                                    style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                )
                              : SizedBox(height: 0),
                          SizedBox(
                            height: 22,
                          ),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              List<List<int>> timingList =
                                  pastList[index].timing;
                              List<TimeOfDay> startTimes = [], endTimes = [];
                              for (int i = 0; i < timingList.length; i++) {
                                startTimes.add(
                                    computeSlot(timingList[i][0].toString()));
                                endTimes.add(
                                    computeSlot(timingList[i][1].toString()));
                              }
                              return card(computeDate(pastList[index].date),
                                  startTimes, endTimes, timingList);
                            },
                            itemCount: pastList.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                          ),
                        ],
                      );
                    }
                  } else {
                    return SpinKitPouringHourGlass(
                      color: Colors.grey,
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

Future<String> deleteResch(
    int docId, String date, List<List<int>> timing) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(delReschUrl),
      body: jsonEncode(
          <String, dynamic>{"doc_id": docId, "date": date, "timing": timing}),
      headers: header);
  if (response.statusCode == 200) {
    return "Rescheduled Timing Successfully Deleted!";
  } else {
    return "Some error occurred in Deleting the Rescheduled Timing!";
  }
}

Future<Map<String, List>> getResch(int docId) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(getReschUrl),
      body: jsonEncode(<String, dynamic>{"doc_id": docId}),
      headers: header);
  if (response.statusCode == 200) {
    debugPrint(response.body);
    var jsonResponse = json.decode(response.body.toString());
    ReschResponse jsonResp = ReschResponse.fromJson(jsonResponse);
    var upList = jsonResp.upcomingResch;
    var pastList = jsonResp.pastResch;
    return {"up": upList, "past": pastList};
  } else {
    return {"up": [], "past": []};
  }
}

class ReschResponse {
  final List<DoctorRescheduleModel> upcomingResch;
  final List<DoctorRescheduleModel> pastResch;

  ReschResponse({required this.upcomingResch, required this.pastResch});

  factory ReschResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["Upcoming"] as List;
    List<DoctorRescheduleModel> upReschList =
        list.map((i) => DoctorRescheduleModel.fromJson(i)).toList();
    var list1 = parsedJson["Past"] as List;
    List<DoctorRescheduleModel> pastReschList =
        list1.map((i) => DoctorRescheduleModel.fromJson(i)).toList();
    return ReschResponse(upcomingResch: upReschList, pastResch: pastReschList);
  }
}

DateTime computeDate(String d) {
  List<String> strings = d.toString().split("-");
  int year = int.parse(strings[0]);
  int month = int.parse(strings[1]);
  int day = int.parse(strings[2]);
  DateTime date = DateTime(year, month, day);
  return date;
}

TimeOfDay computeSlot(String d) {
  d = d.padLeft(4, "0");
  int hours = int.parse(d.substring(0, 2));
  int minutes = int.parse(d.substring(2, 4));
  TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
  return slot;
}
