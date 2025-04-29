class ErrorResponseModel {
  List<Errors>? _erros;
  List<Errors>? get errors => _erros;

  ErrorResponseModel({
    List<Errors>? erros
  }) {
    _erros = erros;
  }

  ErrorResponseModel.fromJson(dynamic json) {
    if(json['errors'] != null) {
      _erros = [];
      json['errors'].forEach((v) {
          _erros!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic> {};
    if(_erros != null) {
      map['errors'] = _erros!.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class Errors {
  String? _code;
  String? _message;

  String? get code => _code;
  String? get message => _message;

  Errors({String? code, String? message}) {
    _code = code;
    _message = message;
  }

  Errors.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic> {};
    map['code'] = _code;
    map['message'] = _message;

    return map;
  }
}