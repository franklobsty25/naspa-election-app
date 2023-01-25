class PresidentModel {
  int votes;

  PresidentModel(this.votes);

  Map<String, dynamic> toFirestore() {
    return {"votes": votes};
  }

  factory PresidentModel.fromFirestore(Map<String, dynamic> snapshot) {
    return PresidentModel(snapshot["votes"]);
  }
}
