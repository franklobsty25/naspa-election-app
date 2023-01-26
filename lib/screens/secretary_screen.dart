import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:suhum_naspa/models/double_candidate_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class SecretaryScreen extends StatefulWidget {
  const SecretaryScreen({super.key});

  @override
  State<SecretaryScreen> createState() => _SecretaryScreenState();
}

class _SecretaryScreenState extends State<SecretaryScreen> {
  bool loading = false;
  bool sLoading = false;

  void onCandidateOneVoting(context) async {
    setState(() {
      loading = true;
    });

    try {
      final existingVotes = await CandidateService().fetchCandidateVotes('s_1');

      final sec = DoubleCandidateModel.fromFirestore(existingVotes.data());
      ++sec.votes;

      await CandidateService().countVoting(
        's_1',
        sec.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, organiserScreen);

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
      final existingVotes = await CandidateService().fetchCandidateVotes('s_2');

      final sec2 = DoubleCandidateModel.fromFirestore(existingVotes.data());
      ++sec2.votes;

      await CandidateService().countVoting(
        's_2',
        sec2.toFirestore(),
      );

      Navigator.pushReplacementNamed(context, organiserScreen);

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
            'Secretarial Candidates',
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
              'Joshua Kojo Agbehoho',
              'images/sec.jpeg',
              true,
            ),
            SizedBox(height: 5.h),
            candidateWidget(
              context,
              'Joycelyn Asamoah',
              'images/sec2.jpeg',
              false,
            ),
            SizedBox(height: 5.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  organiserScreen,
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
            child: Image.asset(candidateImage, height: 20.h),
          ),
        ),
        SizedBox(height: 2.h),
        Align(
          alignment: Alignment.topCenter,
          child: Text(candidateName),
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
