import 'package:yandex_mapkit/yandex_mapkit.dart';

class ContactInfo {
  final String title;
  final String info;

  ContactInfo({
    required this.title,
    required this.info,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      title: json['title'] ?? '',
      info: json['info'] ?? '',
    );
  }
}

class MapRoute {
  final String route;
  final String color;
  final String text;

  MapRoute({
    required this.route,
    required this.color,
    required this.text,
  });

  factory MapRoute.fromJson(Map<String, dynamic> json) {
    return MapRoute(
      route: json['route'] ?? '',
      color: json['color'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class MapMark {
  final Point coordinates;
  final String icon;
  final String iconColor;
  final String text;

  MapMark({
    required this.coordinates,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  factory MapMark.fromJson(Map<String, dynamic> json) {
    var lng = Point(longitude: 0, latitude: 0);

    if (json['coordinates'] != null) {
      final split = '${json['coordinates']}'.split(',');
      lng = Point(latitude: double.tryParse(split.first) ?? 0, longitude: double.tryParse(split.last) ?? 0);
    }

    return MapMark(
      coordinates: lng,
      icon: json['icon'] ?? '',
      iconColor: json['icon_color'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class MapData {
  final Point center;
  final String color;
  final String zoom;
  final List<String> route;
  final List<MapRoute> path;
  final List<MapMark> mark;

  MapData({
    required this.center,
    required this.color,
    required this.zoom,
    required this.route,
    required this.path,
    required this.mark,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    var lng = Point(latitude: 0, longitude: 0);

    if (json['center'] != null) {
      final split = '${json['center']}'.split(',');
      lng = Point(latitude: double.tryParse(split.first) ?? 0, longitude: double.tryParse(split.last) ?? 0);
    }

    return MapData(
      center: lng,
      color: json['color'] ?? '',
      zoom: json['zoom'] ?? '',
      route: List<String>.from(json['route'] ?? []),
      path: (json['path'] as List<dynamic>).map((e) => MapRoute.fromJson(e)).toList(),
      mark: (json['mark'] as List<dynamic>).map((e) => MapMark.fromJson(e)).toList(),
    );
  }
}

class ContactMapData {
  final List<ContactInfo> contacts;
  final MapData map;

  ContactMapData({
    required this.contacts,
    required this.map,
  });

  factory ContactMapData.fromJson(Map<String, dynamic> json) {
    return ContactMapData(
      contacts: (json['contacts'] as List<dynamic>).map((e) => ContactInfo.fromJson(e)).toList(),
      map: MapData.fromJson(json['map']),
    );
  }
}