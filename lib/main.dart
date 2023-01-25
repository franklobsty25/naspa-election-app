import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:splash_view/splash_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:suhum_naspa/screens/president_screen.dart';
import 'package:suhum_naspa/screens/results_screen.dart';
import 'package:suhum_naspa/screens/thankyou_screen.dart';
import 'package:suhum_naspa/screens/veep_screen.dart';
import 'package:suhum_naspa/screens/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Naspa Election',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.white,
            background: Colors.grey[200],
            tertiary: Colors.deepPurple,
          ),
          textTheme: TextTheme(
            subtitle2: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            headline5: TextStyle(fontSize: 12.sp),
            headline6: TextStyle(fontSize: 10.sp),
            bodyText1: TextStyle(fontSize: 12.sp),
            bodyText2: TextStyle(fontSize: 16.sp, color: Colors.purple),
            button: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        ),
        home: SplashView(
          logo: Image.asset('images/logo.jpeg'),
          done: Done(
            const VerificationScreen(),
            animationDuration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          ),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.blue]),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case verificationScreen:
              return PageTransition(
                child: const VerificationScreen(),
                type: PageTransitionType.rotate,
                alignment: Alignment.bottomCenter,
                duration: const Duration(milliseconds: 1000),
              );
            case presidentScreen:
              return PageTransition(
                child: const PresidentScreen(),
                type: PageTransitionType.topToBottom,
              );
            case veepScreen:
              return PageTransition(
                child: const VeepScreen(),
                type: PageTransitionType.rightToLeft,
              );
            case thankyouScreen:
              return PageTransition(
                child: const ThankyouScreen(),
                type: PageTransitionType.leftToRight,
              );
            case resultsScreen:
              return PageTransition(
                  child: const ResultsScreen(),
                  type: PageTransitionType.topToBottomJoined,
                  childCurrent: this);
            default:
              return null;
          }
        },
      );
    });
  }
}
