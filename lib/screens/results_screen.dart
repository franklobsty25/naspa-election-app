import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:suhum_naspa/components/candidate_component.dart';
import 'package:suhum_naspa/components/single_candidate_component.dart';
import 'package:suhum_naspa/models/double_candidate_model.dart';
import 'package:suhum_naspa/models/single_candidate_model.dart';
import 'package:suhum_naspa/services/candidate_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool loading = false;
  late DoubleCandidateModel prez1Obj;
  late DoubleCandidateModel prez2Obj;
  late SingleCandidateModel veep;
  late DoubleCandidateModel sec1;
  late DoubleCandidateModel sec2;
  late SingleCandidateModel org;
  late SingleCandidateModel wocom;

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
      final prezz1 = DoubleCandidateModel.fromFirestore(prez1Votes.data());

      final prez2Votes = await CandidateService().fetchCandidateVotes('p_2');
      final prezz2 = DoubleCandidateModel.fromFirestore(prez2Votes.data());

      final veepVotes = await CandidateService().fetchCandidateVotes('v_1');
      final veepYNVotes = SingleCandidateModel.fromFirestore(veepVotes.data());

      final sec1Votes = await CandidateService().fetchCandidateVotes('s_1');
      final secz1 = DoubleCandidateModel.fromFirestore(sec1Votes.data());

      final sec2Votes = await CandidateService().fetchCandidateVotes('s_2');
      final secz2 = DoubleCandidateModel.fromFirestore(sec2Votes.data());

      final orgVotes = await CandidateService().fetchCandidateVotes('o_1');
      final orgYNVotes = SingleCandidateModel.fromFirestore(orgVotes.data());

      final wocomVotes = await CandidateService().fetchCandidateVotes('w_1');
      final wocomYNVotes = SingleCandidateModel.fromFirestore(wocomVotes.data());

      setState(() {
        prez1Obj = prezz1;
        prez2Obj = prezz2;
        veep = veepYNVotes;
        sec1 = secz1;
        sec2 = secz2;
        org = orgYNVotes;
        wocom = wocomYNVotes;
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
      appBar: AppBar(
        title: Center(
          child: Text(
            'Newly Elected Naspa Executives',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
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
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CandidateComponent(
                        candidateName: 'Farouk Domson',
                        candidatePosition: 'Presidential',
                        candidateImage: 'images/farouk.jpeg',
                        candidateTotalVote: prez1Obj.votes,
                      ),
                      CandidateComponent(
                        candidateName: 'Okoampah John',
                        candidatePosition: 'Presidential',
                        candidateImage: 'images/john.jpeg',
                        candidateTotalVote: prez2Obj.votes,
                      ),
                    ],
                  ),
                  SingleCandidateComponent(
                    candidateName: 'Phyllis Marfoa Ayeh',
                    candidatePosition: 'Vice Presidential',
                    candidateImage: 'images/veep.jpeg',
                    candidateYesVote: veep.yesVotes,
                    candidateNoVote: veep.noVotes,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CandidateComponent(
                        candidateName: 'Joshua Kojo Agbehoho',
                        candidatePosition: 'Secretary',
                        candidateImage: 'images/sec.jpeg',
                        candidateTotalVote: sec1.votes,
                      ),
                      CandidateComponent(
                        candidateName: 'Joycelyn Asamoah',
                        candidatePosition: 'Secretary',
                        candidateImage: 'images/sec2.jpeg',
                        candidateTotalVote: sec2.votes,
                      ),
                    ],
                  ),
                  SingleCandidateComponent(
                    candidateName: 'Asare Richard Yeboah',
                    candidatePosition: 'Organiser',
                    candidateImage: 'images/org.jpeg',
                    candidateYesVote: org.yesVotes,
                    candidateNoVote: org.noVotes,
                  ),
                  SingleCandidateComponent(
                    candidateName: 'Rhoda Godsway Doklah',
                    candidatePosition: 'Women Commissioner',
                    candidateImage: 'images/wocom.jpg',
                    candidateYesVote: wocom.yesVotes,
                    candidateNoVote: wocom.noVotes,
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
