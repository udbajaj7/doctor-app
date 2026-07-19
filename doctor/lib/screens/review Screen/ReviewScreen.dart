import 'package:doctor/Models/DoctorReview.dart';
import 'package:doctor/Models/PatientModel.dart';
import 'package:doctor/screens/review%20Screen/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../components/size_config.dart';
import '../../components/urls.dart';

class ReviewScreen extends StatelessWidget {
  final List<Color> colorList = [
    Color(0xff4C9928),
    Color(0xff7DCA1A),
    Color(0xffD7DA27),
    Color(0xffE2A917),
    Color(0xffD76331)
  ];

  @override
  Widget build(BuildContext context) {
    initializeHeader();

    SizeConfig().init(context);
    return Scaffold(
      appBar: BasicAppBar("Patient Reviews", context),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getReviewsFuture(myProfile.id),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data as Tuple4;
              List<DoctorReview> reviewList = data.item4;
              List<PatientModel> patientList = data.item3;
              String rating = data.item1;
              List<String> ratingSplit = data.item2;
              if (reviewList.length > 0)
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(10),
                      horizontal: getProportionateScreenHeight(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    getProportionateScreenWidth(40))),
                                color: Colors.grey.shade200),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenWidth(8),
                                  horizontal: getProportionateScreenWidth(16)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    rating: double.parse(rating),
                                    direction: Axis.horizontal,
                                    itemSize: getProportionateScreenWidth(36),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    rating + " ",
                                    style: GoogleFonts.publicSans(
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "out of ",
                                    style: GoogleFonts.publicSans(
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    "5",
                                    style: GoogleFonts.publicSans(
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          patientList.length.toString() + " patient Ratings",
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: getProportionateScreenWidth(24),
                                  width: SizeConfig.screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: colorList[i],
                                  ),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (5 - i).toString() + ".0 ",
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w300,
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                            color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: getProportionateScreenWidth(12),
                                      )
                                    ],
                                  )),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: SizeConfig.screenWidth * 0.55,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Container(
                                      height: 10,
                                      width: SizeConfig.screenWidth *
                                          0.55 *
                                          double.parse(ratingSplit[4 - i]) /
                                          100.0,
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  ratingSplit[4 - i] + " %",
                                  style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFF373737)),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        for (int i = 0; i < reviewList.length; i++)
                          reviewCard(reviewList[i], patientList[i]),
                      ],
                    ),
                  ),
                );
              else
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image.asset("assets/images/no-reviews.jpg"),
                      SizedBox(
                        height: 20,
                      ),
                      Text("No reviews yet",
                          style: GoogleFonts.publicSans(fontSize: 20)),
                    ]));
            }
            return SpinKitPouringHourGlass(color: Colors.grey);
          }),
    );
  }

  Widget reviewCard(DoctorReview review, PatientModel p) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
                radius: getProportionateScreenWidth(16),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                p.firstName + " " + p.lastName,
                style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Expanded(child: Container()),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: getProportionateScreenWidth(24),
                  width: SizeConfig.screenWidth * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: colorList[5 - review.rating],
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        review.rating.toString() + ".0 ",
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w300,
                            fontSize: getProportionateScreenWidth(12),
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: getProportionateScreenWidth(12),
                      )
                    ],
                  )),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Text(
              review.review,
              style: GoogleFonts.publicSans(
                  fontSize: 12, fontWeight: FontWeight.normal),
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            DateFormat('dd MMM yyyy').format(DateTime.parse(review.postedAt)),
            style: GoogleFonts.publicSans(
                color: Color(0xffABABAB),
                fontSize: 12,
                fontWeight: FontWeight.w300),
          )
        ]),
      ),
    );
  }
}

PreferredSizeWidget BasicAppBar(String title, BuildContext context) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    title: Text(
      title,
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
  );
}
