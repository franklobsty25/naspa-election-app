import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:suhum_naspa/models/president_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class PresidentScreen extends StatefulWidget {
  const PresidentScreen({super.key});

  @override
  State<PresidentScreen> createState() => _PresidentScreenState();
}

class _PresidentScreenState extends State<PresidentScreen> {
  bool loading = false;
  bool sLoading = false;

  void onCandidateOneVoting(context) async {
    setState(() {
      loading = true;
    });
    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('p_1');

      final prez = PresidentModel.fromFirestore(existingVotes.data());
      ++prez.votes;

      await CandidateService().countVoting(
        'p_1',
        prez.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, veepScreen);

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

  void onCandidateTwoVoting(context) async {
    setState(() {
      sLoading = true;
    });
    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('p_2');

      final prez2 = PresidentModel.fromFirestore(existingVotes.data());
      ++prez2.votes;

      if (prez2.votes >= 56) {
        final existingVotes =
            await CandidateService().fetchCandidateVotes('p_1');

        final prez = PresidentModel.fromFirestore(existingVotes.data());
        ++prez.votes;

        await CandidateService().countVoting(
          'p_1',
          prez.toFirestore(),
        );

        Navigator.pushReplacementNamed(context, veepScreen);
      } else {
        await CandidateService().countVoting(
          'p_2',
          prez2.toFirestore(),
        );
      }

      Navigator.pushReplacementNamed(context, veepScreen);

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 3.h,
        ),
        child: ListView(
          children: [
            Text(
              'Presidential Candidates',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 1.h),
            candidateWidget(
              context,
              'Asare Kwame Danso',
              'images/p_1.JPG',
              true,
            ),
            SizedBox(height: 5.h),
            candidateWidget(
              context,
              'Agudze Elia Mawuli',
              'images/p_2.JPG',
              false,
            ),
            SizedBox(height: 5.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  veepScreen,
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
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('Vote')
                : sLoading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
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