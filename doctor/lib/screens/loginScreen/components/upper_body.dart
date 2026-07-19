import 'package:flutter/material.dart';

List<Widget> upperBody(BuildContext context, double scaffoldHeight) {
  return [
    SizedBox(
      height: MediaQuery.of(context).padding.top,
    ),
    SizedBox(
      height: scaffoldHeight * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.white,
            child: Image.asset("assets/images/plus1.png", fit: BoxFit.contain),
          )
        ],
      ),
    ),
  ];
}


