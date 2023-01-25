class VeepModel {
  int votes;

  VeepModel(this.votes);

  Map<String, dynamic> toFirestore() {
    return {"votes": votes};
  }

  factory VeepModel.fromFirestore(Map<String, dynamic> snapshot) {
    return VeepModel(
      snapshot["votes"],
    );
  }
}