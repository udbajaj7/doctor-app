import 'package:doctor/screens/bookings/components/requests.dart';
import 'package:doctor/screens/homeScreen/components/accountsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../../components/size_config.dart';
import '../../../components/urls.dart';

import '../../../Models/PatientModel.dart';
import '../../allPatientScreen/allPatientScreen.dart';

class EditPatAlertDialog extends StatefulWidget {
  final PatientModel patientModel;
  final Function refresh;
  EditPatAlertDialog({required this.patientModel, required this.refresh});

  @override
  State<EditPatAlertDialog> createState() => _EditPatAlertDialogState();
}

class _EditPatAlertDialogState extends State<EditPatAlertDialog> {
  List<String> genderList = ["Male", "Female", "Others"];
  late String select;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    select = widget.patientModel.gender;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return LoaderOverlay(
      overlayWidget: Material(
        color: Colors.white,
        child: Center(
            child: SpinKitPouringHourGlass(
          color: Colors.grey,
        )),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
                      ])),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w600,
                          fontSize: getProportionateScreenWidth(13),
                          color: Colors.black),
                    )),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () async {
                      _scaffoldKey.currentContext!.loaderOverlay.show();
                      editPatientDetail(widget.patientModel).then((value) {
                        _scaffoldKey.currentContext!.loaderOverlay.hide();
                        widget.refresh();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text("Confirm Edits!",
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w600,
                            fontSize: getProportionateScreenWidth(13),
                            color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildFirstName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "First Name",
          style: headingStyle,
        ),
        TextFormField(
          initialValue: widget.patientModel.firstName,
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
              widget.patientModel.firstName = value;
            });
          },
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
          initialValue: widget.patientModel.lastName,
          style: inputStyle,
          decoration: inputDecoration,
          onChanged: (value) {
            setState(() {
              widget.patientModel.lastName = value;
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
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          initialValue: widget.patientModel.phoneNumber,
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
                  widget.patientModel.phoneNumber.length.toString() + "/10",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: widget.patientModel.phoneNumber.length != 10
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
              if (value.length == 10)
                FocusManager.instance.primaryFocus!.unfocus();

              widget.patientModel.phoneNumber = value;
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
          initialValue: (widget.patientModel.age == -1)
              ? ""
              : widget.patientModel.age.toString(),
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
              widget.patientModel.age = int.parse(value);
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
                fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Radio(
            activeColor: Colors.black,
            value: genderList[btnValue],
            groupValue: select,
            onChanged: (value) {
              setState(() {
                select = value.toString();
                widget.patientModel.gender = value.toString();
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
}
