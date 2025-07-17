import 'chain_product.dart';

class ChainModel {
  Map<String, dynamic>? totalPrice;
  Map<String, dynamic>? totalSave;
  Map<String, dynamic>? totalPrev;
  Map<String, dynamic>? showSpecialPrice;
  Map<String, dynamic>? disabledIfSpecial;
  Map<String, dynamic>? totalSaveInt;
  Map<String, List<ChainProductModel>>? products;

  ChainModel({this.totalPrice, this.totalSave, this.totalPrev, this.showSpecialPrice, this.disabledIfSpecial, this.totalSaveInt, this.products});

  ChainModel.fromJson(Map<String, dynamic> json) {
    totalPrice = json['total_price'];
    totalSave = json['total_save'];
    totalPrev = json['total_prev'];
    showSpecialPrice = json['show_special_price'];
    disabledIfSpecial = json['disabled_if_special'];
    totalSaveInt = json['total_save_int'];
    
    if (json['products'] != null) {
      Map<String, List<ChainProductModel>> items = {};

      json['products'].forEach((key, val) {
        List<ChainProductModel> products = [];

        for (var i in val) {
          products.add(ChainProductModel.fromJson(i));
        }

        items.putIfAbsent(key, () => products);
      });

      products = items;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_price'] = totalPrice;
    data['total_save'] = totalSave;
    data['total_prev'] = totalPrev;
    data['show_special_price'] = showSpecialPrice;
    data['disabled_if_special'] = disabledIfSpecial;
    data['total_save_int'] = totalSaveInt;
    data['products'] = products;
    return data;
  }
}