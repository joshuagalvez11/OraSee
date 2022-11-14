import 'dart:collection';

class UserModel {
  String? uid;
  String? lastName;
  String? firstName;
  String? email;
  String? options;
  String? phone;
  Queue<String>? seekerQueue;
  Queue<dynamic>? volunteerQueue;

  UserModel({
    this.email,
    this.firstName,
    this.lastName,
    this.options,
    this.uid,
    this.phone,
    this.seekerQueue,
    this.volunteerQueue,
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

  void addSeekerToQueue(String id) {
    final queue = Queue<String>();
    queue.add(id);
    seekerQueue = queue;
  }

  void addVolunteerToQueue(String id) {
    final queue = Queue<String>();
    queue.add(id);
    volunteerQueue = queue;
  }

  void removeSeekerFromQueue(String id) {
    final queue = Queue<String>();
    queue.remove(id);
    // seekerQueue.remove(id);
  }

  Queue<String> removeVolunteerFromQueue(String id) {
    final queue = Queue<String>();
    queue.remove(id);
    return queue;
  }
}
