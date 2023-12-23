class Userauth {
  final String id;
  final String fullName;
  final String email;
  final String number;
  final String country;
  final DateTime dob;
  final String gender;
  Userauth({required this.id, required this.fullName, required this.email, required this.number,required this.country, required this.dob, required this.gender});
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