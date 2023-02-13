class Voter {
  final int voterID;
  final String citizenshipId;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String state;
  final String district;
  final int wardNo;
  final String municipality;

  Voter(
      this.voterID,
      this.citizenshipId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.address,
      this.state,
      this.district,
      this.wardNo,
      this.municipality);
}
