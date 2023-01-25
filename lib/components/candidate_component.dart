import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CandidateComponent extends StatelessWidget {
  final String candidateName;
  final String candidatePosition;
  final String candidateImage;
  final int candidateTotalVote;
  const CandidateComponent({
    super.key,
    required this.candidateName,
    required this.candidatePosition,
    required this.candidateImage,
    required this.candidateTotalVote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Card(
            elevation: 50,
            shadowColor: Colors.black45,
            child: Image.asset(candidateImage, height: 20.h),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          candidateName,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 2.h),
        Text(
          candidatePosition,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 2.h),
        Text('Total votes $candidateTotalVote'),
        SizedBox(height: 5.h),
      ],
    );
  }
}
