import 'package:yandex_mapkit/yandex_mapkit.dart';

class ContactLocationModel {
  late String title;
  late String map;
  late String wa;
  late String tg;
  late Point lng;

  ContactLocationModel({required this.title, required this.map, required this.wa, required this.tg, required this.lng});
}