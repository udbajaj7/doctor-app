import 'package:doctor/screens/allPatientScreen/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Models/PatientModel.dart';
import '../../components/size_config.dart';
import '../../components/urls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/requests.dart';

class AllPatientScreen extends StatefulWidget {
  @override
  State<AllPatientScreen> createState() => _AllPatientScreenState();
}

class _AllPatientScreenState extends State<AllPatientScreen> {
  List<PatientModel> patListToDisplay = [];
  late Future<List<PatientModel>> patListFuture;
  bool added = false;

  @override
  void initState() {
    super.initState();
    patListFuture = getAllPatientsFuture(myProfile.id);
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
          "All Patients",
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
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(getProportionateScreenWidth(100)),
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
      body: FutureBuilder(
          future: getAllPatientsFuture(myProfile.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PatientModel> patList = snapshot.data as List<PatientModel>;
              return AllPatientsBody(patList: patList);
            } else
              return SpinKitHourGlass(color: Colors.grey);
          }),
    );
  }

  void searchPat(String query) {
    final suggestions = patListToDisplay.where((pat) {
      final patName = (pat.firstName + " " + pat.lastName).toLowerCase();
      final input = query.toLowerCase();
      return patName.contains(input);
    }).toList();
    setState(() {
      if (query == "") added = false;
      patListToDisplay = suggestions;
    });
  }
}
