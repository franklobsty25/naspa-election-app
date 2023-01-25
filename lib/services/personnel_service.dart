import 'package:cloud_firestore/cloud_firestore.dart';

class PersonnelService {
  CollectionReference personnels =
      FirebaseFirestore.instance.collection('personnels');

  Future getPersonnel(String nssNumber) async {
    try {
      DocumentSnapshot documentSnapshot = await personnels.doc(nssNumber).get();

      return documentSnapshot;
    } catch (e) {
      throw e.toString();
    }
  }

  Future fetchAllPersonnel() async {
    try {
      final allPersonnels = await personnels.get();

      return allPersonnels;
    } catch (e) {
      throw e.toString();
    }
  }

  Future countAsVoted(String nssNumber, Map<String, dynamic> data) async {
    try {
      final documentSnapshot = await personnels.doc(nssNumber).update(data);

      return documentSnapshot;
    } catch (e) {
      throw e.toString();
    }
  }
}
