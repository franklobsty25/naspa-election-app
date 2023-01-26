import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:suhum_naspa/models/single_candidate_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class WocomScreen extends StatefulWidget {
  const WocomScreen({super.key});

  @override
  State<WocomScreen> createState() => _WocomScreenState();
}

class _WocomScreenState extends State<WocomScreen> {
  bool loading = false;
  bool sLoading = false;

  void onYesVoting(context) async {
    setState(() {
      loading = true;
    });

    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('w_1');

      final wocom = SingleCandidateModel.fromFirestore(existingVotes.data());
      ++wocom.yesVotes;

      await CandidateService().countVoting(
        'w_1',
        wocom.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, thankyouScreen);

      Timer(
        const Duration(seconds: 1),
        () => (setState(() {
          loading = false;
        })),
      );
    } catch (e) {
      showToastMessage(context, e.toString());
    }
  }

  void onNoVoting(context) async {
    setState(() {
      sLoading = true;
    });

    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('w_1');

      final wocom2 = SingleCandidateModel.fromFirestore(existingVotes.data());
      ++wocom2.noVotes;

      await CandidateService().countVoting(
        'w_1',
        wocom2.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, thankyouScreen);

      Timer(
        const Duration(seconds: 1),
        () => (setState(() {
          sLoading = false;
        })),
      );
    } catch (e) {
      showToastMessage(context, e.toString());
    }
  }

  void showToastMessage(context, String errorMessage) {
    showToast(
      errorMessage,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Women Commissioner Candidate',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
        child: ListView(
          children: [
            candidateWidget(
              context,
              'Rhoda Godsway Doklah',
              'images/wocom.jpg',
              true,
            ),
            SizedBox(height: 20.h),
            // candidateWidget(
            //   context,
            //   'Agudze Elia Mawuli',
            //   'images/p_2.JPG',
            //   false,
            // ),
            // SizedBox(height: 5.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  thankyouScreen,
                ),
                child: const Text('Skip'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget candidateWidget(
    BuildContext context,
    String candidateName,
    String candidateImage,
    bool active,
  ) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 20,
            shadowColor: Colors.black45,
            child: Image.asset(candidateImage),
          ),
        ),
        SizedBox(height: 2.h),
        Align(
          alignment: Alignment.topCenter,
          child: Text(candidateName),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30.w,
              height: 5.h,
              child: ElevatedButton(
                onPressed: loading ? null : () => onYesVoting(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: loading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('Yes'),
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              width: 30.w,
              height: 5.h,
              child: ElevatedButton(
                onPressed: sLoading ? null : () => onNoVoting(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: sLoading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('No'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
