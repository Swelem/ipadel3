class Userauth {
  String id;
  String fName;
  String lName;
  String email;
  String number;
  String country;
  String dob;
  String gender;
  get getId => this.id;

  set setId(final id) => this.id = id;

  get getfName => this.fName;

  set setfName(fName) => this.fName = fName;

  get getlName => this.lName;

  set setlName(fName) => this.lName = lName;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getNumber => this.number;

  set setNumber(number) => this.number = number;

  get getCountry => this.country;

  set setCountry(country) => this.country = country;

  get getDob => this.dob;

  set setDob(dob) => this.dob = dob;

  get getGender => this.gender;

  set setGender(gender) => this.gender = gender;
  Userauth(
      {required this.id,
      required this.fName,
      required this.lName,
      required this.email,
      required this.number,
      required this.country,
      required this.dob,
      required this.gender});
  // factory Userauth.fromJson(Map<String, dynamic> parsedJson) {
  //   return Userauth(
  //       email: parsedJson['email'] ?? '',
  //       fName: parsedJson['firstName'] ?? '',
  //       lName: parsedJson['lastName'] ?? '',
  //       id: parsedJson['uid'] ?? parsedJson['uid'] ?? '',
  //       number: parsedJson['number'] ?? '',
  //       country: parsedJson['nationality'] ?? '',
  //       dob: parsedJson['dob'] ?? '',
  //       gender: parsedJson['gender'] ?? '');
  //   //profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  // }

  factory Userauth.fromJson(Map<String, dynamic> parsedJson) {
    return Userauth(
        id: parsedJson['uid'] ?? parsedJson['uid'] ?? '',
        fName: parsedJson['firstName'] ?? '',
        lName: parsedJson['lastName'] ?? '',
        email: parsedJson['email'] ?? '',
        number: parsedJson['number'] ?? '',
        country: parsedJson['nationality'] ?? '',
        dob: parsedJson['dob'] ?? '',
        gender: parsedJson['gender'] ?? '');
  }
  // id = data['uid'],
  //   fName = data['First Name'],
  //   lName = data['Last Name'],
  //   email = data['Email'],
  //   number = data['Number'],
  //   country = data['Country'],
  //   dob = data['DOB'],
  //   gender = data['Gender'];
  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'First Name': fName,
      'Last Name': lName,
      'Email': email,
      'Number': number,
      'Country': country,
      'DOB': dob,
      'Gender': gender,
    };
  }
}
