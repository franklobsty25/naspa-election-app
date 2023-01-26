class DoubleCandidateModel {
  int votes;

  DoubleCandidateModel(this.votes);

  Map<String, dynamic> toFirestore() {
    return {"votes": votes};
  }

  factory DoubleCandidateModel.fromFirestore(Map<String, dynamic> snapshot) {
    return DoubleCandidateModel(snapshot["votes"]);
  }
}
