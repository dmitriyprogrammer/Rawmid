import 'cart.dart';

class OrdersModel {
  late String id;
  late String total;
  late String status;
  DateTime? dateAdded;
  late String shipping;
  late String print;
  late String comment;
  late String avatar;
  late String address;
  late String payLink;
  late String payText;
  late int payD;
  late int end;
  late bool cancel;
  late List<CartModel> products;
  late List<HistoryOrder> history;
  late List<TotalOrder> totals;

  OrdersModel(
      {required this.id,
        required this.total,
        required this.status,
        required this.dateAdded,
        required this.shipping,
        required this.print,
        required this.comment,
        required this.avatar,
        required this.address,
        required this.payLink,
        required this.payText,
        required this.payD,
        required this.end,
        required this.cancel,
        required this.products,
        required this.history,
        required this.totals});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    status = json['status'];
    dateAdded = DateTime.tryParse('${json['date_added']}');
    shipping = json['shipping'];
    print = json['print'];
    comment = json['comment'];
    avatar = json['avatar'];
    address = json['address'];
    payLink = json['pay_link'] ?? '';
    payText = json['pay_text'] ?? '';
    payD = json['payd'];
    end = json['end'];
    cancel = (int.tryParse('${json['can_cancel']}') ?? 0) == 1;
    products = <CartModel>[];
    if (json['products'] != null) {
      json['products'].forEach((v) {
        products.add(CartModel.fromJson(v));
      });
    }
    history = <HistoryOrder>[];
    if (json['history'] != null) {
      json['history'].forEach((v) {
        history.add(HistoryOrder.fromJson(v));
      });
    }
    totals = <TotalOrder>[];
    if (json['totals'] != null) {
      json['totals'].forEach((v) {
        totals.add(TotalOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total'] = total;
    data['status'] = status;
    data['date_added'] = dateAdded;
    data['shipping'] = shipping;
    data['print'] = print;
    data['comment'] = comment;
    data['avatar'] = avatar;
    data['address'] = address;
    data['pay_link'] = payLink;
    data['pay_text'] = payText;
    data['payd'] = payD;
    data['end'] = end;
    data['can_cancel'] = cancel;
    data['products'] = products.map((v) => v.toJson()).toList();
    data['history'] = history.map((v) => v.toJson()).toList();
    data['totals'] = totals.map((v) => v.toJson()).toList();
    return data;
  }
}

class HistoryOrder {
  late String id;
  late String comment;
  late String status;
  DateTime? date;

  HistoryOrder({required this.id, required this.comment, required this.status, required this.date});

  HistoryOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    status = json['status'];
    date = DateTime.tryParse('${json['date']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['status'] = status;
    data['date'] = date;
    return data;
  }
}

class TotalOrder {
  late String title;
  late String text;

  TotalOrder({required this.title, required this.text});

  TotalOrder.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['text'] = text;
    return data;
  }
}