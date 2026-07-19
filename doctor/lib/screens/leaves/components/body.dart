import 'dart:convert';
import 'package:doctor/Models/DoctorLeave.dart';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/leaves/AddLeavesScreen.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../providers/httpClientProvider.dart';

class LeaveScreen extends StatefulWidget {
  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final TextStyle headingStyle =
      GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.bold);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          "Leaves",
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 61,
        width: 61,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: IconButton(
          icon: Icon(Icons.add, size: 36, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddLeavesScreen(f)));
          },
        ),
      ),
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
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder(
                future: getLeaves(myProfile.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, List> map = snapshot.data as Map<String, List>;
                    List<DoctorLeaveModel> upList =
                        map["up"] as List<DoctorLeaveModel>;
                    List<DoctorLeaveModel> pastList =
                        map["past"] as List<DoctorLeaveModel>;
                    if (upList.length == 0 && pastList.length == 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2),
                          Image.asset("assets/images/noresch.png"),
                          SizedBox(
                            height: 6,
                          ),
                          Text("No Leaves \n    Added!",
                              style: GoogleFonts.publicSans(
                                  fontWeight: FontWeight.w500, fontSize: 18))
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            upList.length != 0
                                ? Text(
                                    "Upcoming Leaves",
                                    style: headingStyle,
                                  )
                                : SizedBox(height: 0),
                            upList.length != 0
                                ? SizedBox(
                                    height: 22,
                                  )
                                : SizedBox(height: 0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  leaveCard(upList[index]),
                              itemCount: upList.length,
                            ),
                            upList.length != 0
                                ? SizedBox(
                                    height: 42,
                                  )
                                : SizedBox(height: 0),
                            pastList.isEmpty
                                ? SizedBox(height: 0)
                                : Text(
                                    "Past Leaves",
                                    style: headingStyle,
                                  ),
                            pastList.isNotEmpty
                                ? SizedBox(height: 16)
                                : SizedBox(height: 0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  leaveCard(pastList[index]),
                              itemCount: pastList.length,
                            )
                          ],
                        ),
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

  Widget leaveCard(DoctorLeaveModel leave) {
    DateTime startDay =
        computeDate(leave.startTime.split("-").reversed.join("-"));
    DateTime endDay = computeDate(leave.endTime.split("-").reversed.join("-"));
    final diff = startDay.difference(endDay);
    int noOfDays = -diff.inDays;
    return Container(
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(8)),
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
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(noOfDays > 1 ? "$noOfDays Days Leave" : "1 Day Leave",
                      style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B6B6B))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    changeDateTime(startDay) + "  -  " + changeDateTime(endDay),
                    style: headingStyle,
                  )
                ],
              ),
              ClipOval(
                child: Material(
                  color: Color.fromARGB(255, 255, 74, 74),
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Are you sure you want to Delete this leave:",
                              style: headingStyle,
                            ),
                            content: Text(
                              changeDateTime(startDay) +
                                  "  -  " +
                                  changeDateTime(endDay),
                              style: headingStyle,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    String deleteResp = await deleteLeave(
                                        myProfile.id,
                                        leave.startTime
                                            .split("-")
                                            .reversed
                                            .join("-"),
                                        leave.endTime
                                            .split("-")
                                            .reversed
                                            .join("-"));
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
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 14,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> deleteLeave(int docId, String startTime, String endTime) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(deleteLeaveUrl),
      body: jsonEncode(<String, dynamic>{
        "doc_id": docId,
        "start_day": startTime,
        "end_day": endTime
      }),
      headers: header);
  if (response.statusCode == 200) {
    return "Leave Successfully Deleted!";
  } else {
    return "Some error occurred in Deleting Leave!";
  }
}

Future<Map<String, List>> getLeaves(int docId) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(getLeavesUrl),
      body: jsonEncode(<String, dynamic>{"doc_id": docId}),
      headers: header);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    LeaveResponse jsonResp = LeaveResponse.fromJson(jsonResponse);
    List<DoctorLeaveModel> upList = jsonResp.upcomingLeaves;
    List<DoctorLeaveModel> pastList = jsonResp.pastLeaves;
    return {"up": upList, "past": pastList};
  } else {
    return {"up": [], "past": []};
  }
}

class LeaveResponse {
  final List<DoctorLeaveModel> upcomingLeaves;
  final List<DoctorLeaveModel> pastLeaves;

  LeaveResponse({required this.upcomingLeaves, required this.pastLeaves});

  factory LeaveResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["Upcoming"] as List;
    List<DoctorLeaveModel> upLeaveList =
        list.map((i) => DoctorLeaveModel.fromJson(i)).toList();
    var list1 = parsedJson["Past"] as List;
    List<DoctorLeaveModel> pastLeaveList =
        list1.map((i) => DoctorLeaveModel.fromJson(i)).toList();
    return LeaveResponse(
        upcomingLeaves: upLeaveList, pastLeaves: pastLeaveList);
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

String changeDateTime(DateTime dateTime) {
  String day = DateFormat("EEEE").format(dateTime);
  String numberDay = dateTime.day.toString();
  String month = DateFormat.MMMM().format(dateTime);
  return day.substring(0, 3) + " " + numberDay + ", " + month.substring(0, 3);
}
