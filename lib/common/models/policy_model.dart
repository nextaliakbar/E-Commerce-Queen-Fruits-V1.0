import 'package:flutter/cupertino.dart';

class PolicyModel {
  Pages? returnPage;
  Pages? refundPage;
  Pages? cancellationPage;
  String? termsAndCondition;
  String? privacyPolicy;
  String? aboutUs;

  PolicyModel({
    this.returnPage,
    this.refundPage,
    this.cancellationPage,
    this.termsAndCondition,
    this.privacyPolicy,
    this.aboutUs
  });
  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
    returnPage: Pages.fromJson(json: json['return_page']),
    refundPage: Pages.fromJson(json: json['refund_page']),
    cancellationPage: Pages.fromJson(json: json['cancellation_page']),
    termsAndCondition: json['terms_and_conditions'],
    privacyPolicy: json['privacy_policy'],
    aboutUs: json['about_us']
  );

  Map<String, dynamic> toJson() => {
    "return_page": returnPage?.toJson(),
    "refund_page": refundPage?.toJson(),
    "cancellation_page": cancellationPage?.toJson(),
    "terms_and_condition": termsAndCondition,
    "privacy_policy": privacyPolicy,
    "about_us":aboutUs
  };
}

class Pages {
  bool? status;
  String? content;
  Pages({this.status, this.content});

  factory Pages.fromJson({required Map<String, dynamic> json}) {
    Pages? pages;

    try {
      pages = Pages(
          status: int.parse(json['status'].toString()) == 1 ? true : false,
          content: json['content']);
    } catch(e) {
      pages = null;
    }

    return pages!;
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "content": content
  };
}
