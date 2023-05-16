import 'dart:convert';
EpgItem epgItemFromJson(String str) => EpgItem.fromJson(json.decode(str));
String epgItemToJson(EpgItem data) => json.encode(data.toJson());
class EpgItem {
  EpgItem({
      List<Channels>? channels, 
      num? responseCode, 
      bool? status, 
      String? today,}){
    _channels = channels;
    _responseCode = responseCode;
    _status = status;
    _today = today;
}

  EpgItem.fromJson(dynamic json) {
    if (json['channels'] != null) {
      _channels = [];
      json['channels'].forEach((v) {
        _channels?.add(Channels.fromJson(v));
      });
    }
    _responseCode = json['responseCode'];
    _status = json['status'];
    _today = json['today'];
  }
  List<Channels>? _channels;
  num? _responseCode;
  bool? _status;
  String? _today;
EpgItem copyWith({  List<Channels>? channels,
  num? responseCode,
  bool? status,
  String? today,
}) => EpgItem(  channels: channels ?? _channels,
  responseCode: responseCode ?? _responseCode,
  status: status ?? _status,
  today: today ?? _today,
);
  List<Channels>? get channels => _channels;
  num? get responseCode => _responseCode;
  bool? get status => _status;
  String? get today => _today;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_channels != null) {
      map['channels'] = _channels?.map((v) => v.toJson()).toList();
    }
    map['responseCode'] = _responseCode;
    map['status'] = _status;
    map['today'] = _today;
    return map;
  }

}

Channels channelsFromJson(String str) => Channels.fromJson(json.decode(str));
String channelsToJson(Channels data) => json.encode(data.toJson());
class Channels {
  Channels({
      String? name, 
      List<Programs>? programs,}){
    _name = name;
    _programs = programs;
}

  Channels.fromJson(dynamic json) {
    _name = json['name'];
    if (json['programs'] != null) {
      _programs = [];
      json['programs'].forEach((v) {
        _programs?.add(Programs.fromJson(v));
      });
    }
  }
  String? _name;
  List<Programs>? _programs;
Channels copyWith({  String? name,
  List<Programs>? programs,
}) => Channels(  name: name ?? _name,
  programs: programs ?? _programs,
);
  String? get name => _name;
  List<Programs>? get programs => _programs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_programs != null) {
      map['programs'] = _programs?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Programs programsFromJson(String str) => Programs.fromJson(json.decode(str));
String programsToJson(Programs data) => json.encode(data.toJson());
class Programs {
  Programs({
      String? name, 
      num? duration,
      String? url,}){
    _name = name;
    _duration = duration;
    _url = url;
}

  Programs.fromJson(dynamic json) {
    _name = json['name'];
    _duration = json['duration'];
    _url = json['url'];
  }
  String? _name;
  num? _duration;
  String? _url;
Programs copyWith({  String? name,
  num? duration,
  String? url,
}) => Programs(  name: name ?? _name,
  duration: duration ?? _duration,
  url: url ?? _url,
);
  String? get name => _name;
  num? get duration => _duration;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['duration'] = _duration;
    map['url'] = _url;
    return map;
  }

}