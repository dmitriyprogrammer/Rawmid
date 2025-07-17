import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/model/catalog/manufacturer.dart';
import 'attribute.dart';

class CategoryItemModel {
  late List<ProductModel> products;
  late List<AttributeModel> attributes;
  late List<ManufacturerModel> manufacturers;
  late int total;
  late double minPrice;
  late double maxPrice;

  CategoryItemModel({required this.products, required this.attributes, required this.manufacturers, required this.total, required this.minPrice, required this.maxPrice});

  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductModel>[];
      
      json['products'].forEach((v) {
        products.add(ProductModel.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <AttributeModel>[];
      
      json['attributes'].forEach((v) {
        attributes.add(AttributeModel.fromJson(v));
      });
    }
    if (json['manufacturers'] != null) {
      manufacturers = <ManufacturerModel>[];
      
      json['manufacturers'].forEach((v) {
        manufacturers.add(ManufacturerModel.fromJson(v));
      });
    }

    total = int.tryParse('${json['total']}') ?? 0;
    minPrice = double.tryParse('${json['min_price']}') ?? 0;
    maxPrice = double.tryParse('${json['max_price']}') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['products'] = products.map((v) => v.toJson()).toList();
    data['attributes'] = attributes.map((v) => v.toJson()).toList();
    data['manufacturers'] = manufacturers.map((v) => v.toJson()).toList();
    data['total'] = total;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
    return data;
  }
}