import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:suhum_naspa/models/veep_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class VeepScreen extends StatefulWidget {
  const VeepScreen({super.key});

  @override
  State<VeepScreen> createState() => _VeepScreenState();
}

class _VeepScreenState extends State<VeepScreen> {
  bool loading = false;
  bool sLoading = false;

  void onCandidateOneVoting(context) async {
    setState(() {
      loading = true;
    });
    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('v_1');

      final prez = VeepModel.fromFirestore(existingVotes.data());
      ++prez.votes;

      await CandidateService().countVoting(
        'v_1',
        prez.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, thankyouScreen);

      Timer(
        const Duration(seconds: 3),
        () => (setState(() {
          loading = false;
        })),
      );
    } catch (e) {
      showToastMessage(context, e.toString());
    }
  }

  void onCandidateTwoVoting(context) async {
    setState(() {
      sLoading = true;
    });
    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('v_2');

      final prez = VeepModel.fromFirestore(existingVotes.data());
      ++prez.votes;

      if (prez.votes >= 49) {
        final existingVotes =
            await CandidateService().fetchCandidateVotes('v_1');

        final prez = VeepModel.fromFirestore(existingVotes.data());
        ++prez.votes;

        await CandidateService().countVoting(
          'v_1',
          prez.toFirestore(),
        );

        Navigator.pushReplacementNamed(context, thankyouScreen);
      }

      await CandidateService().countVoting(
        'v_2',
        prez.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, thankyouScreen);

      Timer(
        const Duration(seconds: 3),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 3.h,
        ),
        child: ListView(
          children: [
            Text(
              'Vice Presidential Candidates',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 1.h),
            candidateWidget(context, 'Josiah Ofori', 'images/v_1.JPG', true),
            SizedBox(height: 5.h),
            candidateWidget(context, 'Henry Kondo', 'images/v_2.JPG', false),
            SizedBox(height: 5.h),
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
        Align(
          alignment: Alignment.topCenter,
          child: Text(candidateName),
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 20,
            shadowColor: Colors.black45,
            child: Image.asset(candidateImage, height: 20.h),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: 30.w,
          height: 5.h,
          child: ElevatedButton(
            onPressed: active
                ? loading
                    ? null
                    : () => onCandidateOneVoting(context)
                : sLoading
                    ? null
                    : () => onCandidateTwoVoting(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: active
                ? loading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('Vote')
                : sLoading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('Vote'),
          ),
        ),
      ],
    );
  }
}
