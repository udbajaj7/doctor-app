// import 'dart:convert';
// import 'dart:core';
// import 'dart:io';
// import 'package:doctor/components/size_config.dart';
// import 'package:doctor/screens/addPatientScreen/AddPatientScreen.dart';
// import 'package:doctor/screens/homeScreen/components/accountsScreen.dart';
// import 'package:doctor/components/urls.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final TabController tabController;
//   final BuildContext ctx;
//   final List<String> appBarMenuItems = ["Add Patient", "Delay"];
//   CustomAppBar(this.tabController, this.ctx);

//   Future<bool> _onWillPop() async {
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle(
//           statusBarColor: Colors.white,
//           statusBarIconBrightness: Brightness.dark,
//           statusBarBrightness: Brightness.light,
//         ),
//         title: Text(
//           "INCUE",
//           style: GoogleFonts.josefinSans(
//               fontWeight: FontWeight.w700, color: Colors.black, fontSize: 20),
//         ),
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         leading: InkWell(
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => AccountsScreen()));
//           },
//           child: Transform.translate(
//               offset: Offset(14, 0),
//               child: Container(
//                 margin: EdgeInsets.all(14),
//                 height: 32,
//                 width: 32,
//                 child: CircleAvatar(
//                   backgroundColor: Color.fromARGB(255, 196, 196, 196),
//                   child: Icon(
//                     Icons.person,
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 ),
//               )),
//         ),
//         bottom: TabBar(
//           controller: tabController,
//           labelColor: Color.fromARGB(255, 22, 111, 193),
//           unselectedLabelColor: Colors.grey,
//           labelStyle:
//               GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600),
//           unselectedLabelStyle:
//               GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w400),
//           tabs: [
//             Tab(
//               text: "Reached",
//             ),
//             Tab(text: "Booking")
//           ],
//         ),
//         actions: [
//           InkWell(
//             onTap: () async {
//               TimeOfDay? picked = Platform.isAndroid
//                   ? await showTimePicker(
//                       context: ctx,
//                       initialTime: TimeOfDay(hour: 0, minute: 15),
//                       initialEntryMode: TimePickerEntryMode.input,
//                       builder: (context, childWidget) {
//                         return MediaQuery(
//                             data: MediaQuery.of(context).copyWith(
//                                 // Using 24-Hour format
//                                 alwaysUse24HourFormat: true),
//                             // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
//                             child: childWidget!);
//                       },
//                     )
//                   : await showCupertinoModalPopup(
//                       context: context,
//                       builder: (_) => Container(
//                             height: getProportionateScreenHeight(500),
//                             color: const Color.fromARGB(255, 255, 255, 255),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: getProportionateScreenHeight(400),
//                                   child: CupertinoDatePicker(
//                                       mode: CupertinoDatePickerMode.time,
//                                       use24hFormat: true,
//                                       initialDateTime: DateTime.now(),
//                                       onDateTimeChanged: (val) {}),
//                                 ),

//                                 // Close the modal
//                                 CupertinoButton(
//                                   child: const Text('OK'),
//                                   onPressed: () => Navigator.of(context).pop(),
//                                 )
//                               ],
//                             ),
//                           ));
//               print("time picked for delay ");
//               print(picked);
//               if (picked == null) {
//               } else {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (context) => WillPopScope(
//                             onWillPop: _onWillPop,
//                             child: SpinKitPouringHourGlass(
//                               color: Colors.grey,
//                             ),
//                           )),
//                 );
//               }
//               var result = await addDelay(myProfile.id, picked!);
//               print("after future");
//               print(result);
//               Navigator.pop(context);
//               if (result != "Success")
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//                   content:
//                       Text("There was some error and delay could not be added"),
//                 ));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1, color: Colors.black)),
//               child: Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Center(
//                   child: Icon(
//                     Icons.more_time_sharp,
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           InkWell(
//             onTap: () async {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => AddPatientScreen(
//                     age: -1,
//                     firstName: "",
//                     gender: "",
//                     getEarly: false,
//                     lastName: "",
//                     phoneNumber: "",
//                     refreshIndicatorKey: null,
//                     treatment: ""),
//               ));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1, color: Colors.black)),
//               child: Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Center(
//                   child: Icon(
//                     Icons.person_add_alt,
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 22,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight + 50);
// }


