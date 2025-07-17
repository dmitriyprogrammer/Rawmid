import 'package:rawmid/model/ur.dart';
import 'address.dart';

class ProfileModel {
  late String fio;
  late String firstname;
  late String lastname;
  late String otch;
  late String image;
  late String rangStr;
  late String phone;
  late String email;
  late bool type;
  late bool subscription;
  late bool push;
  late int rang;
  late UrProfile ur;
  late List<AddressModel> address;

  ProfileModel({required this.fio, required this.firstname, required this.lastname, required this.otch, required this.image, required this.rangStr, required this.phone, required this.email, required this.type, required this.subscription, required this.push, required this.rang, required this.ur, required this.address});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    fio = json['fio'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    otch = json['otch'];
    image = json['image'];
    rangStr = json['rang_str'];
    phone = json['phone'];
    email = json['email'];
    type = json['type'];
    subscription = json['subscription'];
    push = json['push'];
    rang = json['rang'];
    ur = UrProfile.fromJson(json['ur']);

    List<AddressModel> items = [];

    for (var i in json['address']) {
      items.add(AddressModel.fromJson(i));
    }

    address = items;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fio'] = fio;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['otch'] = otch;
    data['image'] = image;
    data['rang_str'] = rangStr;
    data['phone'] = phone;
    data['email'] = email;
    data['type'] = type;
    data['subscription'] = subscription;
    data['push'] = push;
    data['rang'] = rang;
    data['ur'] = ur;
    data['address'] = address;
    return data;
  }
}