import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/components/candidate_component.dart';
import 'package:suhum_naspa/models/president_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool loading = false;
  late int prez1;
  late int prez2;
  late int veep1;
  late int veep2;

  @override
  void initState() {
    _getElectionResults();
    super.initState();
  }

  void _getElectionResults() async {
    setState(() {
      loading = true;
    });
    try {
      final prez1Votes = await CandidateService().fetchCandidateVotes('p_1');
      final prezz1 = PresidentModel.fromFirestore(prez1Votes.data());

      final prez2Votes = await CandidateService().fetchCandidateVotes('p_2');
      final prezz2 = PresidentModel.fromFirestore(prez2Votes.data());

      final veep1Votes = await CandidateService().fetchCandidateVotes('v_1');
      final veepz1 = PresidentModel.fromFirestore(veep1Votes.data());

      final veep2Votes = await CandidateService().fetchCandidateVotes('v_2');
      final veepz2 = PresidentModel.fromFirestore(veep2Votes.data());

      setState(() {
        prez1 = prezz1.votes;
        prez2 = prezz2.votes;
        veep1 = veepz1.votes;
        veep2 = veepz2.votes;
        loading = false;
      });
    } catch (e) {
      showToast(
        e.toString(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 2.h,
              ),
              child: ListView(
                children: [
                  Text(
                    'Newly Elected Naspa Executives',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CandidateComponent(
                        candidateName: 'Asare Kwame Danso',
                        candidatePosition: 'Presidential Candidate',
                        candidateImage: 'images/p_1.JPG',
                        candidateTotalVote: prez1,
                      ),
                      CandidateComponent(
                        candidateName: 'Agudze Elia Mawuli',
                        candidatePosition: 'Presidential Candidate',
                        candidateImage: 'images/p_2.JPG',
                        candidateTotalVote: prez2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CandidateComponent(
                        candidateName: 'Josiah Ofori',
                        candidatePosition: 'Vice Presidential Candidate',
                        candidateImage: 'images/v_1.JPG',
                        candidateTotalVote: veep1,
                      ),
                      CandidateComponent(
                        candidateName: 'Henry Kondo',
                        candidatePosition: 'Vice Presidential Candidate',
                        candidateImage: 'images/v_2.JPG',
                        candidateTotalVote: veep2,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  TextButton(
                    onPressed: () => _getElectionResults(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
    );
  }
}
