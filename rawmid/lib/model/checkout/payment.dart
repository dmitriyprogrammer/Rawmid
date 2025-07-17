class PaymentModel {
  final String code;
  final String title;
  final String terms;
  final String sortOrder;
  final String paymentDiscount;

  PaymentModel({
    required this.code,
    required this.title,
    required this.terms,
    required this.sortOrder,
    required this.paymentDiscount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      code: json['code'],
      title: json['title'],
      terms: json['terms'] ?? '',
      sortOrder: '${json['sort_order'] ?? ''}',
      paymentDiscount: json['payment_discount'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'terms': terms,
      'sort_order': sortOrder,
      'payment_discount': paymentDiscount,
    };
  }
}