// import 'dart:convert';
// import 'package:doctor/Models/DoctorBookings.dart';
// import 'package:doctor/Models/MedicalFiles.dart';
// import 'package:doctor/Models/PatientModel.dart';
// import 'package:doctor/components/size_config.dart';
// import 'package:doctor/screens/bookings/components/patientAllBookingsScreen.dart';
// import 'package:doctor/screens/bookings/components/requests.dart';
// import 'package:doctor/screens/homeScreen/components/Helper.dart';
// import 'package:doctor/screens/homeScreen/components/requests.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tuple/tuple.dart';

// class PatientDetailWeb extends StatefulWidget {
//   PatientModel patientModel;
//   Function showAddPatientScreen;
//   PatientDetailWeb(this.patientModel, this.showAddPatientScreen);

//   @override
//   State<PatientDetailWeb> createState() => _PatientDetailWebState();
// }

// class _PatientDetailWebState extends State<PatientDetailWeb> {
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       fit: FlexFit.loose,
//       flex: 1,
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white, boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 5,
//             offset: Offset(0, 0),
//           ),
//         ]),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: FutureBuilder(
//             future: getPatientAllBookings(widget.patientModel.id),
//             builder: (context, snapshot) {
//               if (snapshot.hasData &&
//                   snapshot.connectionState == ConnectionState.done) {
//                 List<DoctorBookingsModel> bookingList =
//                     snapshot.data as List<DoctorBookingsModel>;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: getProportionateScreenHeight(12)),
//                     Text("Patients Details",
//                         style: GoogleFonts.publicSans(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                             fontSize: 18)),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.014,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Name:",
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14)),
//                               Text(
//                                   widget.patientModel.firstName +
//                                       " " +
//                                       widget.patientModel.lastName,
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Age:",
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14)),
//                               Text(widget.patientModel.age.toString(),
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Gender:",
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14)),
//                               Text(widget.patientModel.gender,
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Mobile:",
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14)),
//                               SelectableText(
//                                   widget.patientModel.phoneNumber.toString(),
//                                   style: GoogleFonts.publicSans(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600))
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           Center(
//                             child: TextButton(
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty
//                                       .all<OutlinedBorder>(RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(
//                                                   getProportionateScreenHeight(
//                                                       24))))),
//                                   elevation:
//                                       MaterialStateProperty.all<double>(10),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.black)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Book Another Appointment",
//                                   style: GoogleFonts.publicSans(
//                                       fontSize:
//                                           getProportionateScreenHeight(20),
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 widget.showAddPatientScreen(AddPatientModel(
//                                     widget.patientModel.firstName,
//                                     widget.patientModel.lastName,
//                                     widget.patientModel.age,
//                                     widget.patientModel.phoneNumber,
//                                     "Checkup",
//                                     widget.patientModel.gender,
//                                     false));
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: getProportionateScreenHeight(12)),
//                     Text("Booking Details",
//                         style: GoogleFonts.publicSans(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                             fontSize: 18)),
//                     Expanded(
//                       child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: bookingList.length,
//                           itemBuilder: (context, index) {
//                             DateTime dateOfBooking = convertStringToDateTime(
//                                 bookingList[index].date,
//                                 int.parse(bookingList[index].slotTime));
//                             Color color = Color.fromARGB(255, 226, 169, 23);
//                             String status = "Upcoming";
//                             if (DateTime.now().isAfter(dateOfBooking)) {
//                               status = "Completed";
//                               color = Colors.green;
//                             }
//                             return Column(
//                               children: [
//                                 ListTile(
//                                   trailing: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             getProportionateScreenWidth(12),
//                                         vertical:
//                                             getProportionateScreenHeight(6)),
//                                     decoration: BoxDecoration(
//                                         color: color,
//                                         borderRadius: BorderRadius.circular(3)),
//                                     child: Text(status,
//                                         style: GoogleFonts.publicSans(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white)),
//                                   ),
//                                   contentPadding: EdgeInsets.zero,
//                                   subtitle: Text(
//                                     bookingList[index].date +
//                                         " | " +
//                                         intComputeSlot(int.parse(
//                                                 bookingList[index].slotTime))
//                                             .format(context),
//                                     style: GoogleFonts.publicSans(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 12,
//                                         color:
//                                             Color.fromARGB(255, 106, 106, 106)),
//                                   ),
//                                   title: Text(
//                                     bookingList[index].treatment,
//                                     style: GoogleFonts.publicSans(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () => {
//                                     // print("booking id is ${bookingList[index].bookingId}");
//                                     showDialog(
//                                       context: context,
//                                       builder: (_contex) => documentDialog(
//                                           bookingList[index].bookingId,
//                                           _contex,
//                                           bookingList[index].fileAvailable),
//                                     )
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.attachment,
//                                         color: Colors.blue,
//                                       ),
//                                       Text(
//                                         "Attached Files",
//                                         style: GoogleFonts.publicSans(
//                                             color: Colors.blue),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Divider(
//                                     color: Color.fromARGB(255, 230, 230, 230),
//                                     thickness: 0.6),
//                               ],
//                             );
//                           }),
//                     ),
//                   ],
//                 );
//               } else
//                 return SpinKitPouringHourGlass(color: Colors.grey);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// AlertDialog documentDialog(
//     int bookingId, BuildContext context, bool? filesAvailable) {
//   return AlertDialog(
//     backgroundColor: Colors.white,
//     content: SizedBox(
//       height: SizeConfig.screenHeight * 0.6,
//       width: SizeConfig.screenWidth * 0.6,
//       child: FutureBuilder(
//           future: getTreatmentFiles(bookingId),
//           builder: (context, snapshot) {
//             if (snapshot.hasData &&
//                 snapshot.connectionState == ConnectionState.done) {
//               var p = snapshot.data
//                   as Tuple2<List<MedicalFiles>, List<MedicalFiles>>;
//               List<MedicalFiles> images = p.item1;
//               List<MedicalFiles> documents = p.item2;
//               return Column(
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(
//                         child: Text(
//                           filesAvailable == true
//                               ? "Attached files"
//                               : "Upload Files",
//                           style: GoogleFonts.publicSans(
//                               fontSize: getProportionateScreenHeight(20),
//                               fontWeight: FontWeight.w700),
//                         ),
//                       ),
//                       Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                               icon: Icon(Icons.upload),
//                               onPressed: () async {
//                                 String message = "File uploaded succesfully";
//                                 String response = await uploadFile(bookingId,
//                                     context, documents.length + images.length);
//                                 if (response == "Error")
//                                   message =
//                                       "File could not be added due to some error";
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(message)));
//                                 Navigator.of(context).pop();
//                               }))
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Image files",
//                     style: GoogleFonts.publicSans(
//                         fontSize: getProportionateScreenHeight(16),
//                         fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                         itemCount: images.length,
//                         itemBuilder: (_context, index) {
//                           print(getProportionateScreenWidth(100));
//                           print(getProportionateScreenHeight(60));
//                           print(SizeConfig.screenHeight);
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.grey, width: 0.2)),
//                                 height: getProportionateScreenHeight(100),
//                                 width: getProportionateScreenWidth(150),
//                                 child: Image.memory(
//                                   base64Decode(images[index].fileData),
//                                 )),
//                           );
//                         },
//                         scrollDirection: Axis.horizontal),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Document Files",
//                     style: GoogleFonts.publicSans(
//                         fontSize: getProportionateScreenHeight(16),
//                         fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Expanded(
//                       child: ListView.builder(
//                           itemCount: documents.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               leading: Icon(
//                                 Icons.file_open,
//                                 color: Colors.green,
//                               ),
//                               title: Text(documents[index].fileName),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                       onPressed: () async {
//                                         var response = await deleteFileApi(
//                                             bookingId,
//                                             documents[index].fileName);
//                                         String message =
//                                             "File deleted successfully";
//                                         if (response == "Error")
//                                           message =
//                                               "Could not delete file due to some error";
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 content: Text(message)));
//                                         Navigator.of(context).pop();
//                                       },
//                                       icon: Icon(
//                                         Icons.delete,
//                                         color: Colors.red,
//                                       )),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.download,
//                                       color: Colors.blue,
//                                     ),
//                                     onPressed: () {
//                                       downloadFile(documents[index]);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }))
//                 ],
//               );
//             }
//             return SpinKitPouringHourGlass(color: Colors.grey);
//           }),
//     ),
//   );
// }
