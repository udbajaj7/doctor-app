import 'dart:convert';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:http/http.dart' as http;

class AddLeavesScreen extends StatefulWidget {
  final Function refreshParent;
  AddLeavesScreen(this.refreshParent);
  @override
  State<AddLeavesScreen> createState() => _AddLeavesScreenState();
}

class _AddLeavesScreenState extends State<AddLeavesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String startDate = DateTime.now().day.toString().padLeft(2, "0") +
          "-" +
          DateTime.now().month.toString().padLeft(2, "0") +
          "-" +
          DateTime.now().year.toString(),
      endDate =
          DateTime.now().add(Duration(days: 1)).day.toString().padLeft(2, "0") +
              "-" +
              DateTime.now()
                  .add(Duration(days: 1))
                  .month
                  .toString()
                  .padLeft(2, "0") +
              "-" +
              DateTime.now().add(Duration(days: 1)).year.toString();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.5,
      child: Scaffold(
          key: scaffoldKey,
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
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "From",
                      style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF909090)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      startDate,
                      style: GoogleFonts.publicSans(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Divider(color: Color(0xFFEAEAEA), thickness: 0.6),
                    SizedBox(
                      height: 16,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          height: SizeConfig.screenHeight * 0.5,
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: DateRangePickerWidget(
                              doubleMonth: false,
                              theme: CalendarTheme(
                                selectedColor: Colors.black,
                                dayNameTextStyle: TextStyle(
                                    color: Colors.black45, fontSize: 10),
                                inRangeColor: Color(0xFFD9EDFA),
                                inRangeTextStyle:
                                    TextStyle(color: Colors.black),
                                selectedTextStyle:
                                    TextStyle(color: Colors.white),
                                todayTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                defaultTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                radius: getProportionateScreenWidth(10),
                                tileSize: getProportionateScreenHeight(40),
                                disabledTextStyle:
                                    TextStyle(color: Colors.grey),
                              ),
                              initialDateRange: DateRange(DateTime.now(),
                                  DateTime.now().add(Duration(days: 1))),
                              onDateRangeChanged: _onSelectionChanged,
                            ),
                          ))
                    ]),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "To",
                      style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF909090)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      endDate,
                      style: GoogleFonts.publicSans(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: TextButton(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.publicSans(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              color: Colors.black,
                              height: 60,
                              width: double.infinity,
                            ),
                            onPressed: () async {
                              scaffoldKey.currentContext!.loaderOverlay.show();
                              String leaveStatus = await addLeave(
                                  myProfile.id, startDate, endDate);
                              widget.refreshParent();
                              scaffoldKey.currentContext!.loaderOverlay.hide();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(leaveStatus)));
                            }),
                      ),
                    )
                  ],
                )),
          )),
    );
  }

  void _onSelectionChanged(DateRange? args) {
    if (args != null) {
      setState(() {
        final DateTime? rangeStartDate = args.start;
        final DateTime? rangeEndDate = args.end;
        if (rangeStartDate != null) {
          startDate = rangeStartDate.day.toString().padLeft(2, "0") +
              "-" +
              rangeStartDate.month.toString().padLeft(2, "0") +
              "-" +
              rangeStartDate.year.toString();
        }
        if (rangeEndDate != null) {
          endDate = rangeEndDate.day.toString().padLeft(2, "0") +
              "-" +
              rangeEndDate.month.toString().padLeft(2, "0") +
              "-" +
              rangeEndDate.year.toString();
        }
      });
    }
  }
}

Future<String> addLeave(int docId, String startTime, String endTime) async {
  var response = await http.post(Uri.parse(addLeaveUrl),
      body: jsonEncode(<String, dynamic>{
        "doc_id": docId,
        "start_day": startTime,
        "end_day": endTime
      }),
      headers: header);
  if (response.statusCode == 200) {
    return "Leave Successfully Added!";
  } else {
    return "Some error occurred in adding Leave!";
  }
}
