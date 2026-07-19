import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: Platform.isAndroid
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: Color.fromARGB(255, 187, 187, 187),
              ),
              onPressed: press as void Function(),
              child: Text(
                text,
                style: GoogleFonts.publicSans(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
            )
          : CupertinoButton(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
              onPressed: press as void Function()),
    );
  }
}
