class Userauth {
  String id;
  String fullName;
  String email;
  String number;
  String country;
  DateTime dob;
  String gender;
  get getId => this.id;

  set setId(final id) => this.id = id;

  get getFullName => this.fullName;

  set setFullName(fullName) => this.fullName = fullName;

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
      required this.fullName,
      required this.email,
      required this.number,
      required this.country,
      required this.dob,
      required this.gender});
  Userauth.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        number = data['number'],
        country = data['country'],
        dob = data['dob'],
        gender = data['gender'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'number': number,
      'country': country,
      'dob': dob,
      'gender': gender,
    };
  }
}
