import 'package:doctor/Models/PatientModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/size_config.dart';
import '../../bookings/components/patientAllBookingsScreen.dart';

class AllPatientsBody extends StatefulWidget {
  final List<PatientModel> patList;

  AllPatientsBody({required this.patList});

  @override
  State<AllPatientsBody> createState() => _AllPatientsBodyState();
}

class _AllPatientsBodyState extends State<AllPatientsBody> {
  List<PatientModel> patientsToDisplay = [];
  RefreshController _refreshReschedule =
      RefreshController(initialRefresh: true);

  void f() {
    setState(() {
      _refreshReschedule.refreshCompleted();
    });
  }

  @override
  void initState() {
    super.initState();
    patientsToDisplay = widget.patList;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SmartRefresher(
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
        physics: ScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(12)),
              Text("Patients List",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18)),
              SizedBox(height: getProportionateScreenHeight(20)),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ]),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    child: TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      textCapitalization: TextCapitalization.words,
                      onChanged: searchPat,
                      style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          hintText: "Search for Patients:",
                          hintStyle: GoogleFonts.publicSans(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenWidth(14.5))),
                    )),
              ),
              ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(12)),
                  child: Divider(
                    thickness: 0.6,
                    color: Color.fromARGB(255, 234, 234, 234),
                  ),
                ),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: patientsToDisplay.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PatientAllBookingsScreen(
                            patientsToDisplay[index], f),
                      ));
                    },
                    title: Text(
                      patientsToDisplay[index].firstName +
                          " " +
                          patientsToDisplay[index].lastName,
                      style: GoogleFonts.publicSans(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      patientsToDisplay[index].gender +
                          ", " +
                          patientsToDisplay[index].age.toString(),
                      style: GoogleFonts.publicSans(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: CircleAvatar(
                      child: Text(
                        patientsToDisplay[index].id.toString(),
                        style: GoogleFonts.publicSans(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      radius: getProportionateScreenWidth(30),
                      backgroundColor: Colors.black.withOpacity(0.04),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void searchPat(String query) {
    final suggestions = widget.patList.where((pat) {
      final patName = (pat.firstName + " " + pat.lastName).toLowerCase();
      final input = query.toLowerCase();
      return patName.contains(input);
    }).toList();
    setState(() => patientsToDisplay = suggestions);
  }
}
