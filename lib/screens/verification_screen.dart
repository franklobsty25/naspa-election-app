import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/constants/constant.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:suhum_naspa/models/personnel_model.dart';
import 'package:suhum_naspa/services/personnel_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late CountdownTimerController endController;
  late CountdownTimerController startController;
  final TextEditingController textController = TextEditingController();
  int startTime = DateTime.parse('2023-01-27T09:30:00Z').millisecondsSinceEpoch;
  int endTime = DateTime.parse('2023-01-27T12:00:00Z').millisecondsSinceEpoch;
  bool loading = false;
  bool startElection = false;
  bool electionStarted = true;
  String notice = 'Election starts in';

  @override
  void initState() {
    startController = CountdownTimerController(
      endTime: startTime,
      onEnd: _onStart,
    );
    endController = CountdownTimerController(
      endTime: endTime,
      onEnd: _onEnd,
    );
    super.initState();
  }

  void _onSubmit(context) async {
    setState(() {
      loading = true;
    });

    try {
      final documentsnapshot = await PersonnelService().getPersonnel(
        textController.text.trim().toUpperCase(),
      );

      if (documentsnapshot.data() == null) {
        setState(() {
          loading = false;
        });
        showToastMessage('Nss Number not found');
      } else {
        final personnel = PersonnelModel.fromFirestore(
          documentsnapshot.data(),
        );

        GetStorage().write('name', personnel.name);

        if (personnel.voted) {
          setState(() {
            loading = false;
          });
          showToastMessage('Sorry, Nss number voted already.');
        } else {
          await PersonnelService().countAsVoted(
            textController.text.trim().toUpperCase(),
            {"voted": true},
          );

          Navigator.pushReplacementNamed(context, presidentScreen);
        }

        Timer(
          const Duration(seconds: 1),
          () => (setState(() {
            loading = false;
          })),
        );
      }
    } catch (e) {
      showToastMessage(e.toString());
    }
  }

  showToastMessage(String errorMessage) {
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

  void _onStart() {
    setState(() {
      startElection = true;
      electionStarted = false;
      notice = 'Election ends in';
    });
  }

  void _onEnd() {
    setState(() {
      startElection = false;
      electionStarted = false;
      notice = 'Election has closed';
    });
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Verifcation',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.w,
        ),
        child: ListView(
          children: [
            Icon(Icons.lock_person_outlined, size: 30.w),
            SizedBox(height: 10.h),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                label: const Text('Enter Nss Number'),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 2.h,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 5.h,
              child: ElevatedButton(
                onPressed: startElection
                    ? loading
                        ? null
                        : () => _onSubmit(context)
                    : null,
                child: loading
                    ? SizedBox(
                        width: 5.w,
                        height: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : const Text('Verify'),
              ),
            ),
            SizedBox(height: 10.h),
            Center(child: Text(notice)),
            SizedBox(height: 5.h),
            if (startElection)
              Center(
                child: CountdownTimer(
                  controller: endController,
                  endTime: endTime,
                  onEnd: _onEnd,
                  endWidget: const Center(child: Text('Election has closed')),
                ),
              ),
            if (electionStarted)
              Center(
                child: CountdownTimer(
                  controller: startController,
                  endTime: startTime,
                  onEnd: _onStart,
                  endWidget: const Center(child: Text('Election has started')),
                ),
              ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  resultsScreen,
                ),
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
