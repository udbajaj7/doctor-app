import 'package:doctor/screens/bookings/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsHistoryScreen extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  BookingsHistoryScreen({required this.refreshIndicatorKey});
  @override
  State<BookingsHistoryScreen> createState() => _BookingsHistoryScreenState();
}

class _BookingsHistoryScreenState extends State<BookingsHistoryScreen> {
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
          title: Text("Bookings",
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
        body: Body(refreshIndicatorKey: widget.refreshIndicatorKey,));
  }
}
