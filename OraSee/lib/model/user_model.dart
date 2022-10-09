class UserModel {
  String? uid;
  String? lastName;
  String? firstName;
  String? email;
  String? options;
  String? phone;

  UserModel({
    this.email,
    this.firstName,
    this.lastName,
    this.options,
    this.uid,
    this.phone,
  });

  // RECEIVE DATA FROM DB
  static UserModel fromJson(json) => UserModel(
        uid: json['uid'],
        email: json['email'],
        lastName: json['lastName'],
        firstName: json['firstName'],
        options: json['options'],
        phone: json['phone'],
      );

  //SENDING DATA TO DB
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "lastName": lastName,
      "firstName": firstName,
      "options": options,
      "phone": phone,
    };
  }
}
