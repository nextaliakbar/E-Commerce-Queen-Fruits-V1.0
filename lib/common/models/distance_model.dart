class DistanceModel {
  List<String>? destinationAddress;
  List<String>? originAddress;
  List<Rows>? rows;
  String? status;

  DistanceModel({
    this.destinationAddress,
    this.originAddress,
    this.rows,
    this.status
  });

  DistanceModel.fromJson(Map<String, dynamic> json) {
    destinationAddress = json['destination_addresses'].cast<String>();
    originAddress = json['origin_addresses'].cast<String>();

    if(json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['destination_addresses'] = destinationAddress;
    data['origin_addresses'] = originAddress;
    if(rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }

    data['status'] = status;

    return data;
  }
}

class Rows {
  List<Elements>? elements;

  Rows({this.elements});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['elements'] != null) {
      elements = [];
      json['elements'].forEach((v) {
        elements!.add(Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (elements != null) {
      data['elements'] = elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  Distance? distance;
  Distance? duration;
  String? status;

  Elements({this.distance, this.duration, this.status});

  Elements.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? Distance.fromJson(json['duration'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Distance {
  String? text;
  double? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}