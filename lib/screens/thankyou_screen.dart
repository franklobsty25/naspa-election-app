import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';

class ThankyouScreen extends StatelessWidget {
  const ThankyouScreen({super.key});

  void onNavigateHome(context) {
    Navigator.pushReplacementNamed(context, verificationScreen);
  }

  @override
  Widget build(BuildContext context) {
    final name = GetStorage().read('name');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        child: ListView(
          children: [
            Text(
              'Thank you for voting',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 10.h),
            if (name != null)
             Text(
              name,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 5.h,
              child: ElevatedButton(
                onPressed: () => onNavigateHome(context),
                child: const Text('Back To Start'),
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, resultsScreen),
                child: const Text(
                  'View Results',
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
