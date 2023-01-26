import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateService {
  CollectionReference candidates =
      FirebaseFirestore.instance.collection('nsawam_candidates');

  Future fetchCandidateVotes(String candidate) async {
    try {
      DocumentSnapshot documentSnapshot = await candidates.doc(candidate).get();

      return documentSnapshot;
    } catch (e) {
      throw e.toString();
    }
  }

  Future countVoting(String candidate, Map<String, dynamic> data) async {
    try {
      final documentSnapshot = await candidates.doc(candidate).update(data);

      return documentSnapshot;
    } catch (e) {
      throw e.toString();
    }
  }
}
