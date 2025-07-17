class OrderModel {
  final int orderId;
  final int storeId;
  String? phone;

  OrderModel({
    required this.orderId,
    required this.storeId,
    this.phone
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: int.tryParse('${json['order_id']}') ?? 0,
        storeId: int.tryParse('${json['store_id']}') ?? 0,
        phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'store_id': storeId,
      'phone': phone,
    };
  }
}