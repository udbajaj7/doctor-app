import 'package:doctor/Models/DoctorModel.dart';
import 'package:doctor/screens/Constants.dart';
import 'package:doctor/screens/doctor%20details/components/details_form_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

String? checkFiledEmpty(String value) {
  if (value.isEmpty)
    return "Enter a valid Input";
  else
    return null;
}

class DetailsForm1 extends StatefulWidget {
  final String phoneNumber;
  DetailsForm1(this.phoneNumber);
  @override
  _DetailsForm1State createState() => _DetailsForm1State();
}

class _DetailsForm1State extends State<DetailsForm1> {
  DoctorModel doctorInfo = DoctorModel(
      id: -1,
      firstName: "",
      lastName: "",
      gender: "",
      age: -1,
      phoneNumber: "",
      email: "",
      registrationNumber: "",
      specialization: "",
      degrees: "",
      appointmentFees: -1,
      clinicName: "",
      clinicAddress: "",
      city: "",
      avgTime: -1,
      patPerSlot: -1,
      timing: [],
      category: "",
      contactNumber: "");
  bool hidePassword = true;
  bool isCitiesLoaded = false;
  List<String> cities = [];
  late Future<List<dynamic>> getCityFuture;
  String category = "Dentist";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    doctorInfo.category = "Dentist";
    doctorInfo.gender = "Male";
  }

  Widget _buildFirstName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First Name",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              onChanged: (value) {
                doctorInfo.firstName = value;
                doctorInfo.phoneNumber = widget.phoneNumber;
              },
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Color.fromARGB(255, 0, 0, 0),
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildLastName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last Name",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              onChanged: (value) => doctorInfo.lastName = value,
              validator: (value) => checkFiledEmpty(value!),
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildAge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Age",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              autofocus: true,
              onChanged: (value) => doctorInfo.age = int.parse(value),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null)
                  return "Enter a Valid Input";
                else
                  return null;
              },
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  List<String> genderList = ["Male", "Female", "Others"];
  String select = "Male";

  Widget _buildGender() {
    Row addRadioButton(int btnValue, String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.publicSans(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Radio(
            activeColor: Colors.black,
            value: genderList[btnValue],
            groupValue: select,
            onChanged: (value) {
              setState(() {
                print(value);
                select = value.toString();
                doctorInfo.gender = value.toString();
              });
            },
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildReg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Registration No.",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              validator: (value) => checkFiledEmpty(value!),
              autofocus: true,
              onChanged: (value) => doctorInfo.registrationNumber = value,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              validator: (value) => checkFiledEmpty(value!),
              autofocus: true,
              onChanged: (value) => doctorInfo.email = value,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Category",
          style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
        ),
        DropdownButton<String>(
            value: category,
            items: categoriesAvailable.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                category = value.toString();
                doctorInfo.category = value.toString();
                debugPrint("Treatment selected is $category");
              });
            })
      ]),
    );
  }

  Widget _buildSpecialization() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specialization",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              onChanged: (value) => doctorInfo.specialization = value,
              cursorColor: Colors.black,
              validator: (value) => checkFiledEmpty(value!),
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildDegree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Degree",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              onChanged: (value) => doctorInfo.degrees = value,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.words,
              validator: (value) => checkFiledEmpty(value!),
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  Widget _buildCity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "City",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
          ),
          TextFormField(
              autofocus: true,
              onChanged: (value) => doctorInfo.city = (value),
              cursorColor: Colors.black,
              validator: (value) => checkFiledEmpty(value!),
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              decoration: getDecoration()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          "Getting Started",
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
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Icon(
                Icons.chevron_left_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            GestureDetector(
              onTap: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState!.save();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsForm2(doctorInfo: doctorInfo),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.84,
                height: MediaQuery.of(context).size.height * 0.06,
                color: Colors.black,
                child: Center(
                    child: Text(
                  "Next",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Personal Details",
                    style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                _buildFirstName(),
                SizedBox(
                  height: 20,
                ),
                _buildLastName(),
                SizedBox(
                  height: 20,
                ),
                _buildAge(),
                SizedBox(
                  height: 20,
                ),
                _buildGender(),
                SizedBox(
                  height: 20,
                ),
                _buildReg(),
                SizedBox(
                  height: 20,
                ),
                _buildEmail(),
                SizedBox(
                  height: 20,
                ),
                _buildCategory(),
                SizedBox(
                  height: 20,
                ),
                _buildSpecialization(),
                SizedBox(
                  height: 20,
                ),
                _buildDegree(),
                SizedBox(
                  height: 20,
                ),
                _buildCity(),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          key: _formKey,
        ),
      ),
    );
  }
}

InputDecoration getDecoration() {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 14),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  );
}
