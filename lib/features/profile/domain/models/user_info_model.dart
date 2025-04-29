class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? phone;
  String? cmFirebaseToken;
  String? loginMedium;
  int? ordersCount;
  int? wishListCount;

  UserInfoModel({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.cmFirebaseToken,
    this.loginMedium,
    this.ordersCount,
    this.wishListCount
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    loginMedium = '${json['login_medium']}';
    ordersCount = int.tryParse(json['orders_count'].toString());
    wishListCount = int.tryParse(json['wishlisht_count'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic> {};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['login_medium'] = loginMedium;
    data['orders_count'] = ordersCount;
    data['wishlist_count'] = wishListCount;
    return data;
  }
}