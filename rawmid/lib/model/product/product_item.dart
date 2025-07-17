import 'package:rawmid/model/home/news.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/model/product/chain.dart';
import 'package:rawmid/model/product/question.dart';
import 'attribute.dart';

class ProductItemModel {
  late String id;
  late String name;
  late String status;
  late String sku;
  late String image;
  late String category;
  late String text;
  late String color;
  late String special;
  late String currency;
  late String price;
  late String schema;
  late String text2;
  late String url;
  late String textKvcproPeriod;
  late double price2;
  late double special2;
  late double kvcproPrice;
  late double sbcreditPrice;
  late List<String> video;
  late int reward;
  late int quantity;
  late String uCen;
  late String hdd;
  late bool allowCredit;
  late bool isZap;
  late bool allowCreditKz;
  DateTime? dateEnd;
  late List<String> images;
  late List<ProductModel> childProducts;
  late List<AttributeProductModel> attributes;
  late List<QuestionModel> questions;
  late List<NewsModel> recipes;
  late List<NewsModel> rec;
  late List<ProductModel> zap;
  late List<NewsModel> surveys;
  ChainModel? chain;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.status,
    required this.sku,
    required this.image,
    required this.category,
    required this.text,
    required this.color,
    required this.special,
    required this.currency,
    required this.price,
    required this.schema,
    required this.text2,
    required this.url,
    required this.textKvcproPeriod,
    required this.price2,
    required this.special2,
    required this.kvcproPrice,
    required this.sbcreditPrice,
    required this.video,
    required this.reward,
    required this.quantity,
    required this.uCen,
    required this.hdd,
    required this.allowCredit,
    required this.isZap,
    required this.allowCreditKz,
    required this.dateEnd,
    required this.images,
    required this.childProducts,
    required this.attributes,
    required this.questions,
    required this.recipes,
    required this.rec,
    required this.zap,
    required this.surveys,
    required this.chain,
  });

  ProductItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    sku = json['sku'];
    image = json['image'];
    category = json['category'];
    text = json['text'];
    color = json['color'];
    special = json['special'];
    currency = json['currency'];
    price = json['price'];
    schema = json['schema'];
    text2 = json['text2'];
    url = json['url'];
    isZap = json['isZap'];
    textKvcproPeriod = json['text_kvcpro_period'];
    price2 = double.tryParse('${json['price2']}') ?? 0;
    special2 = double.tryParse('${json['special2']}') ?? 0;
    kvcproPrice = double.tryParse('${json['kvcpro_price']}') ?? 0;
    sbcreditPrice = double.tryParse('${json['sbcredit_price']}') ?? 0;
    video = json['video'] != null ? json['video'].cast<String>() : [];
    reward = int.tryParse('${json['reward']}') ?? 0;
    quantity = int.tryParse('${json['quantity']}') ?? 0;
    uCen = json['ucen'] ?? '';
    hdd = json['hdd'] ?? '';
    allowCredit = (int.tryParse('${json['allow_credit']}') ?? 0) == 1;
    allowCreditKz = (int.tryParse('${json['allow_credit_kz']}') ?? 0) == 1;

    dateEnd = DateTime.tryParse('${json['date_end']}');

    if (json['images'] != null) {
      images = <String>[];

      for (var i in json['images']) {
        images.add(i);
      }
    }

    childProducts = <ProductModel>[];

    if (json['child_products'] != null) {
      for (var i in json['child_products']) {
        childProducts.add(ProductModel.fromJson(i));
      }
    }

    attributes = <AttributeProductModel>[];

    if (json['attributes'] != null) {
      for (var i in json['attributes']) {
        attributes.add(AttributeProductModel.fromJson(i));
      }
    }

    questions = <QuestionModel>[];

    if (json['questions'] != null) {
      for (var i in json['questions']) {
        questions.add(QuestionModel.fromJson(i));
      }
    }

    recipes = <NewsModel>[];

    if (json['recipes'] != null) {
      for (var i in json['recipes']) {
        recipes.add(NewsModel.fromJson(i));
      }
    }

    surveys = <NewsModel>[];

    if (json['surveys'] != null) {
      for (var i in json['surveys']) {
        surveys.add(NewsModel.fromJson(i));
      }
    }

    rec = <NewsModel>[];

    if (json['rec'] != null) {
      for (var i in json['rec']) {
        rec.add(NewsModel.fromJson(i));
      }
    }

    zap = <ProductModel>[];

    if (json['zap'] != null) {
      for (var i in json['zap']) {
        zap.add(ProductModel.fromJson(i));
      }
    }

    if (json['chain'] != null) {
      chain = ChainModel.fromJson(json['chain']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['sku'] = sku;
    data['image'] = image;
    data['text'] = text;
    data['color'] = color;
    data['special'] = special;
    data['currency'] = currency;
    data['price'] = price;
    data['schema'] = schema;
    data['text2'] = text2;
    data['url'] = url;
    data['isZap'] = isZap;
    data['text_kvcpro_period'] = textKvcproPeriod;
    data['price2'] = price2;
    data['special2'] = special2;
    data['kvcpro_price'] = kvcproPrice;
    data['sbcredit_price'] = sbcreditPrice;
    data['video'] = video;
    data['category'] = category;
    data['reward'] = reward;
    data['quantity'] = quantity;
    data['ucen'] = uCen;
    data['hdd'] = hdd;
    data['allow_credit'] = allowCredit;
    data['allow_credit_kz'] = allowCreditKz;
    data['date_end'] = dateEnd;
    data['images'] = images;
    data['child_products'] = childProducts;
    data['attributes'] = attributes;
    data['questions'] = questions;
    data['recipes'] = recipes;
    data['rec'] = rec;
    data['zap'] = zap;
    data['surveys'] = surveys;
    data['chain'] = chain;
    return data;
  }
}