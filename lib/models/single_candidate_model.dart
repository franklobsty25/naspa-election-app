class SingleCandidateModel {
  int yesVotes;
  int noVotes;

  SingleCandidateModel(this.yesVotes, this.noVotes);

  Map<String, dynamic> toFirestore() {
    return {
      "yes_votes": yesVotes,
      "no_votes": noVotes,
    };
  }

  factory SingleCandidateModel.fromFirestore(Map<String, dynamic> snapshot) {
    return SingleCandidateModel(
      snapshot["yes_votes"],
      snapshot["no_votes"],
    );
  }
}
