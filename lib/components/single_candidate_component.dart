import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SingleCandidateComponent extends StatelessWidget {
  final String candidateName;
  final String candidatePosition;
  final String candidateImage;
  final int candidateYesVote;
  final int candidateNoVote;
  const SingleCandidateComponent({
    super.key,
    required this.candidateName,
    required this.candidatePosition,
    required this.candidateImage,
    required this.candidateYesVote,
    required this.candidateNoVote,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Yes votes: $candidateYesVote'),
            SizedBox(width: 5.w),
            Text('No votes: $candidateNoVote'),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
