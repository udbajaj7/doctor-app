import 'dart:ui';

import 'package:doctor/components/size_config.dart';
import 'package:doctor/screens/addPatientScreen/AddPatientScreen.dart';
import 'package:doctor/screens/doctor%20details/components/details_form_1.dart';
import 'package:doctor/screens/homeScreen/components/requests.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuesScreen extends StatefulWidget {
  final int bookingId, balance;
  final String fName, lName, gender, phoneNumber, notes;
  final int age;
  final String treatment;
  final int installment;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  DuesScreen(
      {required this.refreshIndicatorKey,
      required this.notes,
      required this.bookingId,
      required this.balance,
      required this.fName,
      required this.lName,
      required this.age,
      required this.phoneNumber,
      required this.gender,
      required this.treatment,
      required this.installment});

  @override
  State<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends State<DuesScreen> {
  final TextEditingController _controller1 =
      new TextEditingController(text: "0");

  final TextEditingController _controller2 =
      new TextEditingController(text: "0");

  final TextEditingController _controller3 =
      new TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String notes = "";
    _controller1.text = (widget.balance + widget.installment).toString();
    _controller2.text = (widget.installment).toString();
    _controller3.text = widget.balance.toString();
    return AlertDialog(
      content: Container(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Finances",
                style: GoogleFonts.publicSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Text("Pending Dues:     "),
                Expanded(
                  child: TextFormField(
                    controller: _controller1,
                    onChanged: (value) {
                      if (value.isEmpty || value == "") _controller3.text = "";
                      _controller3.text =
                          (int.parse(value) - int.parse(_controller2.text))
                              .toString();
                    },
                    keyboardType: TextInputType.number,
                    decoration: getDecoration(),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("Amount Paid :      "),
                Expanded(
                  child: TextFormField(
                    controller: _controller2,
                    onChanged: (value) {
                      if (value.isEmpty || value == "") _controller3.text = "";
                      _controller3.text =
                          (-int.parse(value) + int.parse(_controller1.text))
                              .toString();
                    },
                    keyboardType: TextInputType.number,
                    decoration: getDecoration(),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("Final Due :            "),
                Expanded(
                  child: TextFormField(
                    controller: _controller3,
                    keyboardType: TextInputType.number,
                    decoration: getDecoration(),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(8),
                ),
                Text("Notes (if any):     "),
                Container(
                  margin: EdgeInsets.all(18),
                  // padding: EdgeInsets.all(12),

                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ]),
                  child: TextFormField(
                    initialValue: widget.notes,
                    maxLines: 8,
                    onChanged: (value) => notes = value,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
      actions: [
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () async {
              if (notes.isNotEmpty) {
                String output = await addNotes(widget.bookingId, notes),
                    message;
                if (output == "Error") {
                  message = "Error occurred in Adding Notes!";
                } else
                  message = "Notes Added Successfully";

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return AddPatientScreen(
                    refreshIndicatorKey: widget.refreshIndicatorKey,
                    firstName: widget.fName,
                    age: widget.age,
                    gender: widget.gender,
                    lastName: widget.lName,
                    phoneNumber: widget.phoneNumber,
                    treatment: widget.treatment,
                    getEarly: false,
                  );
                },
              ));
            },
            child: Text("Book Follow-up",
                style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionateScreenWidth(13),
                    color: Colors.white))),
        TextButton(
            onPressed: () async {
              String message = "";
              if (notes.isNotEmpty) {
                String output = await addNotes(widget.bookingId, notes);
                if (output == "Error")
                  message += "Error occurred in Adding Notes!";
                else
                  message += "Notes Added Successfully";
              }

              updateBalance(widget.bookingId, int.parse(_controller3.text),
                      int.parse(_controller2.text))
                  .then((value) {
                if (value == "Success") {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Balance updated successfully " +
                          (message != "" ? "& " : "") +
                          message)));
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Balance could not be added due to some error" +
                              (message != "" ? "& " : "") +
                              message)));
                }
              });

              widget.refreshIndicatorKey.currentState!.show();
            },
            style: TextButton.styleFrom(backgroundColor: Colors.black),
            child: Text(
              "Done",
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(13),
                  color: Colors.white),
            ))
      ],
    );
  }
}
