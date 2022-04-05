class VerificationStatusModel {
  final String badgeStatus;
  final String document;

  VerificationStatusModel(this.badgeStatus, this.document);

  factory VerificationStatusModel.fromJson(jsonVerification) {
    final String badgeStatus = jsonVerification['badge_status'];
    final String document = jsonVerification['document'] ?? '';

    return VerificationStatusModel(badgeStatus, document);
  }
}
