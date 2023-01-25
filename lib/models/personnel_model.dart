class PersonnelModel {
  String? name;
  bool voted;

  PersonnelModel(this.name, this.voted);

  Map<String, dynamic> toFirestore() {
    return {"name": name, "voted": voted};
  }

  factory PersonnelModel.fromFirestore(Map<String, dynamic> snapshot) {
    return PersonnelModel(
      snapshot["name"],
      snapshot["voted"],
    );
  }
}
