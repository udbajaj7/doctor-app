import 'package:doctor/components/size_config.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';

class ChangeTreatmentDialogBox extends StatefulWidget {
  final String treatment;
  ChangeTreatmentDialogBox(this.treatment);

  @override
  State<ChangeTreatmentDialogBox> createState() =>
      _ChangeTreatmentDialogBoxState();
}

class _ChangeTreatmentDialogBoxState extends State<ChangeTreatmentDialogBox> {
  late String treatmentSelected;
  @override
  void initState() {
    super.initState();
    treatmentSelected = widget.treatment;
  }

  @override
  Widget build(BuildContext context) {
    print(treatmentSelected);
    return AlertDialog(
      content: Container(
        width: SizeConfig.screenWidth * 0.4,
        child: ListView.builder(
            itemCount: docTreatmentsAvailable.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: docTreatmentsAvailable[index],
                    groupValue: treatmentSelected,
                    onChanged: (value) {
                      setState(() {
                        treatmentSelected = value.toString();
                      });
                    },
                  ),
                  Text(docTreatmentsAvailable[index]),
                ],
              );
            }),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop("");
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(treatmentSelected);
          },
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        )
      ],
    );
  }
}
