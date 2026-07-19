import 'package:doctor/providers/appointmentProvider.dart';
import 'package:doctor/providers/httpClientProvider.dart';
import 'package:doctor/screens/homeScreen/components/body.dart';
import 'package:doctor/screens/homeScreen/homeScreen.dart';
import 'package:doctor/screens/loginScreen/SignUpScreen.dart';
import 'package:flutter/services.dart';
import 'package:doctor/screens/loginScreen/loginScreen.dart';
import 'package:doctor/components/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => ConnectionService()),
      ChangeNotifierProvider(create: (context) => AppointmentProvider())
    ],
      child: RefreshConfiguration(
          footerTriggerDistance: 15,
          dragSpeedRatio: 0.91,
          headerBuilder: () => MaterialClassicHeader(),
          footerBuilder: () => ClassicFooter(),
          enableLoadingWhenNoData: false,
          enableRefreshVibrate: false,
          enableLoadMoreVibrate: false,
          shouldFooterFollowWhenNotFull: (state) {
            // If you want load more with noMoreData state ,may be you should return false
            return false;
          },
          child: MaterialApp(
              localizationsDelegates: [RefreshLocalizations.delegate],
              title: 'INCUE',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  dialogTheme: DialogTheme(
                    backgroundColor: Colors.white,
                  ),
                  buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  )),
              routes: {
                'logIn': (context) => LoginScreen(),
                // 'docDetails': (context) => DoctorDetailScreen(),
                // 'otp': (context) => OtpScreen(),
                'homeScreen': (context) => HomeScreen()
              },
              home: FutureBuilder(
                future: _getMetaData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == "Error")
                      return SpinKitHourGlass(color: Colors.grey);
                    else
                      return metaData.isLoggedIn
                          ? HomeScreenBody()
                          : SignUpScreen();
                  } else
                    return SpinKitPouringHourGlass(color: Colors.grey);
                },
              ))),
    );
  }
}

Future<String> _getMetaData() async {
  prefs = await SharedPreferences.getInstance();
  metaData.isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  if (prefs.getInt('age') != null) myProfile.age = prefs.getInt('age')!;
  if (prefs.getInt('appointmentFees') != null)
    myProfile.appointmentFees = prefs.getInt('appointmentFees')!;
  if (prefs.getInt('avgTime') != null)
    myProfile.avgTime = prefs.getInt("avgTime")!;
  myProfile.city = prefs.getString("city") ?? "";
  myProfile.clinicAddress = prefs.getString("clinicAddress") ?? "";
  myProfile.clinicName = prefs.getString("clinicName") ?? "";
  myProfile.degrees = prefs.getString("degrees") ?? "";
  myProfile.email = prefs.getString("email") ?? "";
  myProfile.firstName = prefs.getString("firstName") ?? "";
  myProfile.gender = prefs.getString("gender") ?? "";
  if (prefs.getInt('currentDocId') != null)
    myProfile.id = prefs.getInt('currentDocId')!;
  myProfile.lastName = prefs.getString("lastName") ?? "";
  if (prefs.getInt('pat_per_slot') != null)
    myProfile.patPerSlot = prefs.getInt("pat_per_slot")!;
  myProfile.phoneNumber = prefs.getString("phoneNumber") ?? "";
  myProfile.registrationNumber = prefs.getString("registrationNumber") ?? "";
  myProfile.specialization = prefs.getString("specialization") ?? "";
  print(metaData.isLoggedIn);

  print(myProfile.firstName);

  return "Done";
}
