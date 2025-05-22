class UserLogData {
  String? phoneNumber;
  String? email;
  String? password;

  UserLogData({this.phoneNumber,this.email, this.password});

  UserLogData.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    data['email'] = email;
    return data;
  }
}
