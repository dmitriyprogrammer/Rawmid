import 'package:rawmid/model/checkout/payment.dart';
import 'package:rawmid/model/checkout/shipping.dart';
import 'package:rawmid/model/checkout/total.dart';

class CheckoutModel {
  late List<ShippingModel> shipping;
  late List<PaymentModel> payment;
  late List<TotalModel> totals;
  late String shippingMethod;
  late String paymentMethod;
  late String zoneId;
  late bool usePrepayment;

  CheckoutModel({
    required this.shipping,
    required this.payment,
    required this.totals,
    required this.shippingMethod,
    required this.paymentMethod,
    required this.zoneId,
    required this.usePrepayment,
  });

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    shipping = <ShippingModel>[];

    if (json['shipping'] != null) {
      for (var i in json['shipping']) {
        shipping.add(ShippingModel.fromJson(i));
      }
    }

    payment = <PaymentModel>[];

    if (json['payment'] != null) {
      for (var i in json['payment']) {
        payment.add(PaymentModel.fromJson(i));
      }
    }

    totals = <TotalModel>[];

    if (json['totals'] != null) {
      for (var i in json['totals']) {
        totals.add(TotalModel.fromJson(i));
      }
    }

    shippingMethod = json['shipping_method'];
    paymentMethod = json['payment_method'];
    zoneId = json['zone_id'];
    usePrepayment = json['use_prepayment'];
  }
}