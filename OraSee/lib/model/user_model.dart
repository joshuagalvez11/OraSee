class UserModel {
  String? uid;
  String? lastName;
  String? firstName;
  String? email;
  String? options;

  UserModel(
      {this.email, this.firstName, this.lastName, this.options, this.uid});

  // RECEIVE DATA FROM DB
  static UserModel fromJson(json) => UserModel(
      uid: json['uid'],
      email: json['email'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      options: json['options']);

  //SENDING DATA TO DB
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "lastName": lastName,
      "firstName": firstName,
      "options": options,
    };
  }
}
