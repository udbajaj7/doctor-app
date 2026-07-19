import 'package:doctor/Models/PrescriptionModel.dart';
import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/prescription/components/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PrescriptionScreen extends StatefulWidget {
  final int bookingID;
  final String patName;
  final String bookingDate;
  const PrescriptionScreen(
      {Key? key,
      required this.bookingID,
      required this.patName,
      required this.bookingDate})
      : super(key: key);

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final TextStyle heading = GoogleFonts.publicSans(
          fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
      subHeading = GoogleFonts.publicSans(
          fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
      italicSubHead = GoogleFonts.publicSans(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.black,
          fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light // For iOS (dark icons)
            ),
        title: Text("Prescription",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20)),
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
              child: Icon(Icons.chevron_left_outlined, color: Colors.black),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getPrescription(widget.bookingID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PrescriptionObject prescriptionObject =
                snapshot.data as PrescriptionObject;

            if (prescriptionObject.bookingId != null) {
              String symptomString = "", diagnosisString = "", testsString = "";
              for (int i = 0;
                  i < prescriptionObject.symptoms!.length - 1;
                  i++) {
                symptomString += prescriptionObject.symptoms![i] + ", ";
              }

              for (int i = 0;
                  i < prescriptionObject.diagnosis!.length - 1;
                  i++) {
                diagnosisString += prescriptionObject.diagnosis![i] + ", ";
              }

              for (int i = 0; i < prescriptionObject.tests!.length - 1; i++) {
                testsString += prescriptionObject.tests![i] + ", ";
              }

              if (symptomString != "" ||
                  prescriptionObject.symptoms!.length == 1) {
                symptomString += prescriptionObject
                    .symptoms![prescriptionObject.symptoms!.length - 1];
              } else
                symptomString = "No symptoms written";

              if (diagnosisString != "" ||
                  prescriptionObject.diagnosis!.length == 1) {
                diagnosisString += prescriptionObject
                    .diagnosis![prescriptionObject.diagnosis!.length - 1];
              } else
                diagnosisString = "No diagnoses written";

              if (testsString != "" || prescriptionObject.tests!.length == 1) {
                testsString += prescriptionObject
                    .tests![prescriptionObject.tests!.length - 1];
              } else
                testsString = "No tests written";

              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(16),
                    horizontal: getProportionateScreenWidth(24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.patName, style: heading),
                        Text(convertToDate(widget.bookingDate), style: heading)
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    Divider(color: Colors.grey, thickness: 0.4),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildSymptoms(symptomString),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildDiagnosis(diagnosisString),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildMedicine(prescriptionObject.medicines),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildTests(testsString),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildNextVisit(prescriptionObject.nextVisit)
                  ],
                ),
              );
            } else
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
                    Image.asset(
                      "assets/images/nobook.png",
                      width: getProportionateScreenWidth(113),
                      height: getProportionateScreenWidth(113),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Text(
                      "No Prescription Created!",
                      style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  ],
                ),
              );
          } else
            return Center(child: SpinKitChasingDots(color: Colors.grey));
        },
      ),
    );
  }

  _buildSymptoms(String symptomString) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Symptoms", style: heading),
      SizedBox(height: getProportionateScreenHeight(8)),
      Text(symptomString,
          style: (symptomString.split(" ")[0] == "No")
              ? subHeading
              : italicSubHead),
    ]);
  }

  _buildDiagnosis(String diagnosisString) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Diagnosis", style: heading),
      SizedBox(height: getProportionateScreenHeight(8)),
      Text(diagnosisString,
          style: (diagnosisString.split(" ")[0] == "No")
              ? subHeading
              : italicSubHead),
    ]);
  }

  _buildMedicine(List<Medicines>? medicines) {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medicine", style: heading),
          SizedBox(height: getProportionateScreenHeight(8)),
          medicines != null
              ? Expanded(
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: medicines.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: getProportionateScreenHeight(8)),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading:
                            Text((index + 1).toString(), style: subHeading),
                        title: Text(
                          medicines[index].name ?? "",
                          style: subHeading,
                        ),
                        subtitle: Text("-" + (medicines[index].frequency ?? ""),
                            style: italicSubHead),
                        trailing: Text((medicines[index].dosage ?? ""),
                            style: italicSubHead),
                      );
                    },
                  ),
                )
              : Text("No medicines added!", style: italicSubHead),
        ],
      ),
    );
  }

  _buildTests(String testsString) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Tests Required", style: heading),
      SizedBox(height: getProportionateScreenHeight(8)),
      Text(testsString,
          style:
              (testsString.split(" ")[0] == "No") ? subHeading : italicSubHead),
    ]);
  }

  _buildNextVisit(String? visitDate) {
    String finalString = visitDate ?? "";
    if (visitDate != null) {
      List<String> strings = visitDate.split("-");
      finalString = strings[2] + "-" + strings[1] + "-" + strings[0];
    }

    return visitDate != null
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Next Visit", style: heading),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(convertToDate(finalString), style: subHeading)
          ])
        : SizedBox(height: 0);
  }
}

String convertToDate(String date) {
  List<String> strings = date.split("-");
  DateTime dateTime = DateTime(
      int.parse(strings[0]), int.parse(strings[1]), int.parse(strings[2]));
  return DateFormat.d().format(dateTime) +
      " " +
      DateFormat.MMMM().format(dateTime) +
      " " +
      DateFormat.y().format(dateTime);
}
