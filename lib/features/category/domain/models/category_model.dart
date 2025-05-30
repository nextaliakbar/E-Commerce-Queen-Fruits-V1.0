class CategoryModel {
  int? _id;
  String? _name;
  int? _parentId;
  int? _position;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  String? _bannerImage;

  CategoryModel({
    int? id,
    String? name,
    int? parentId,
    int? position,
    int? status,
    String? createdAt,
    String? updatedAt,
    String? image,
    String? bannerImage
  }) {
    _id = id;
    _name = name;
    _parentId = parentId;
    _position = position;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _bannerImage = bannerImage;
  }

  String? get bannerImage => _bannerImage;

  String? get image => _image;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get status => _status;

  int? get position => _position;

  int? get parentId => _parentId;

  String? get name => _name;

  int? get id => _id;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _name = json['name'] ?? '';
    _parentId = int.tryParse(json['parent_id'].toString()) ?? 0;
    _position = int.tryParse(json['position'].toString()) ?? 0;
    _status = int.tryParse(json['status'].toString()) ?? 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'] ?? '';
    _bannerImage = json['banner_image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['image'] = _image;
    data['banner_image'] = _bannerImage;
    return data;
  }
}