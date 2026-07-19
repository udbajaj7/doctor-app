import 'package:doctor/components/size_config.dart';
import 'package:doctor/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/urls.dart';

class MultipleProfileScreen extends StatelessWidget {
  const MultipleProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String idsString = prefs.getString("DocIds") ?? "";
    String currentId = prefs.get("currentDocId").toString();
    var ids = idsString.split(',');
    if (ids[ids.length - 1].isEmpty)
      ids.removeAt(ids.length - 1); // removing the last empty value

    String namesString = prefs.getString("DocNames") ?? "";
    var names = namesString.split(',');
    if (names[names.length - 1].isEmpty) names.removeAt(names.length - 1);

    return SizedBox(
      height: getProportionateScreenHeight(100),
      child: Container(
        alignment: Alignment.center,
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: names.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                prefs.setInt("currentDocId", int.parse(ids[index]));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                    (route) => false);
              },
              child: Column(
                children: [
                  Container(
                    width: getProportionateScreenHeight(48),
                    height: getProportionateScreenHeight(48),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                        border: Border.all(
                            color: ids[index] == currentId
                                ? Colors.blueGrey
                                : Colors.white,
                            width: 2.5)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5)),
                      child: FractionallySizedBox(
                        heightFactor: 0.95,
                        widthFactor: 0.95,
                        child: Center(
                          child: Text(
                            names[index][0].toUpperCase(),
                            style: GoogleFonts.publicSans(
                                color: Colors.white,
                                fontSize: getProportionateScreenHeight(24),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(16),
                  ),
                  Text(
                    names[index],
                    style: GoogleFonts.publicSans(
                        color: Colors.black,
                        fontSize: getProportionateScreenHeight(14),
                        fontWeight: ids[index] == currentId
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
