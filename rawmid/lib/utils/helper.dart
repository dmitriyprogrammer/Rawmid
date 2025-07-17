import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/api/home.dart';
import 'package:rawmid/screen/catalog/item.dart';
import 'package:rawmid/screen/news/news.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/news.dart';
import '../model/catalog/category.dart';
import '../screen/product/product.dart';
import '../widget/h.dart';
import '../widget/open_web.dart';
import 'constant.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class Helper {
  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
    final session = Helper.prefs.getString('PHPSESSID');

    if (session == null || session.isEmpty) {
      Helper.prefs.setString('PHPSESSID', '0');
    }

    wishlist.value = Helper.prefs.getStringList('wishlist') ?? [];
    compares.value = Helper.prefs.getStringList('compares') ?? [];

    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'success') {
        Helper.snackBar(text: 'Ваш заказ успешно оформлен');
      } else if (uri.host == 'error') {
        Helper.snackBar(error: true, text: 'Произошла ошибка оплаты');
      } else if (uri.host == 'abort') {
        Helper.snackBar(error: true, text: 'Ваш заказ отменен');
      }
    });
  }

  static late final SharedPreferences prefs;
  static ValueNotifier<List<String>> wishlist = ValueNotifier([]);
  static ValueNotifier<List<String>> compares = ValueNotifier([]);
  static bool compareAlert = Helper.prefs.getBool('compareAlert') ?? false;
  static ValueNotifier<int> trigger = ValueNotifier(0);

  static void snackBar({String text = '', String html = '', String title = '', String yes = 'OK', bool notTitle = false, bool hide = false, bool error = false, bool prev = false, Function? callback, Function? callback2}) {
    showDialog(context: Get.context!, builder: (_) {
      return CupertinoAlertDialog(
        title: notTitle ? null : Text(error ? 'Внимание!' : (title != '' ? title : 'Успешно')),
        actions: [
          if (prev) CupertinoDialogAction(onPressed: () {
            Get.back();
          }, child: const Text('Отмена', style: TextStyle(color: primaryColor))),
          CupertinoDialogAction(onPressed: () {
            if (callback2 != null) {
              Get.back();
              callback2();
            } else if (callback != null) {
              Get.back();
              callback();
            } else {
              Get.back();
            }
          }, child: Text(yes, style: const TextStyle(color: firstColor))),
        ],
        content: html.isNotEmpty ? Html(
            data: html,
            onLinkTap: (val, map, element) {
              if ((val ?? '').isNotEmpty) {
                Helper.openLink(val!);
              }
            }
        ) : SelectableText(text),
      );
    }).then((value) {
      if (callback != null) {
        callback();
      }
    });

    if (hide) {
      Timer.periodic(const Duration(seconds: 2), (timer) {
        timer.cancel();
        Get.back();
      });
    }
  }

  static void closeKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(Get.context!).unfocus();
  }

  static String getNoun(int number, String one, String two, String three, {bool before = true}) {
    var n = number.abs();
    n %= 100;
    if (n >= 5 && n <= 20) {
      return before ? "$number $three" : three;
    }
    n %= 10;
    if (n == 1) {
      return before ? "$number $one" : one;
    }
    if (n >= 2 && n <= 4) {
      return before ? "$number $two" : two;
    }
    return before ? "$number $three" : three;
  }

  static Future launchInBrowser(String url, {String title = ''}) async {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            child: OpenWebView(url: url, title: title)
        )
    );
  }

  static Future openLink(String link) async {
    if (link == '[states]') {
      Get.toNamed('/blog');
      return;
    } else if (link == '[reg]') {
      Get.toNamed('/register');
      return;
    } else if (link == '[sup]') {
      Get.toNamed('/support');
      return;
    }

    if (link.contains('madeindream.com')) {
      final api = await HomeApi.getUrlType(link);

      if (api.key.isNotEmpty) {
        if (api.key == 'product') {
          Get.to(() => ProductView(id: api.value));
        } else if (api.key == 'record') {
          Get.delete<NewsController>();
          Get.put(NewsController(api.value, false, false));
          Get.to(() => NewsView());
        } else if (api.key == 'recipe') {
          Get.delete<NewsController>();
          Get.put(NewsController(api.value, true, false));
          Get.to(() => NewsView());
        } else if (api.key == 'category') {
          try {
            final category = jsonDecode(api.value);
            Get.to(() => CategoryItemView(category: CategoryModel.fromJson(category)));
          } catch (e) {
            debugPrint(e.toString());
            Helper.launchInBrowser(link);
          }
        }
      } else {
        Helper.launchInBrowser(link);
      }
    } else {
      Helper.launchInBrowser(link);
    }
  }

  static Future<XFile?> downloadFileAsXFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      return XFile(file.path);
    }

    return null;
  }

  static String formatPrice(double val, {String symbol = '₽'}) {
    var formatter = NumberFormat.currency(locale: 'ru_RU', symbol: symbol, decimalDigits: 0);
    return formatter.format(val);
  }

  static addCompare(String id) {
    if (!compareAlert) {
      Helper.prefs.setBool('compareAlert', true);
      compareAlert = true;

      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Товар добавлен в сравнения',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: Get.back
                                            )
                                          ]
                                      )
                                  ),
                                  const Divider(height: 1),
                                  h(16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Чтобы сравнить товары:',
                                            style: TextStyle(fontSize: 16)
                                        ),
                                        h(20),
                                        Row(
                                            spacing: 6,
                                            children: [
                                              Text(
                                                  'Откройте меню',
                                                  style: TextStyle(fontSize: 14)
                                              ),
                                              Image.asset('assets/icon/burger.png')
                                            ]
                                        ),
                                        h(8),
                                        Text(
                                            'Перейдите в раздел “Сравнение товаров”',
                                            style: TextStyle(fontSize: 14)
                                        ),
                                        h(20)
                                      ]
                                    )
                                  )
                                ]
                            )
                          ]
                      )
                  )
                ]
              )
          )
      );
    }

    if (compares.value.contains(id)) {
      compares.value.remove(id);
    } else {
      compares.value.add(id);
    }

    Helper.prefs.setStringList('compares', compares.value);
    trigger.value++;
  }

  static double getTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: ui.TextDirection.ltr
    )..layout(maxWidth: maxWidth);

    return textPainter.height;
  }

  static const isoCodeConversionMap = {
    "AC": IsoCode.AC,
    "AD": IsoCode.AD,
    "AE": IsoCode.AE,
    "AF": IsoCode.AF,
    "AG": IsoCode.AG,
    "AI": IsoCode.AI,
    "AL": IsoCode.AL,
    "AM": IsoCode.AM,
    "AO": IsoCode.AO,
    "AR": IsoCode.AR,
    "AS": IsoCode.AS,
    "AT": IsoCode.AT,
    "AU": IsoCode.AU,
    "AW": IsoCode.AW,
    "AX": IsoCode.AX,
    "AZ": IsoCode.AZ,
    "BA": IsoCode.BA,
    "BB": IsoCode.BB,
    "BD": IsoCode.BD,
    "BE": IsoCode.BE,
    "BF": IsoCode.BF,
    "BG": IsoCode.BG,
    "BH": IsoCode.BH,
    "BI": IsoCode.BI,
    "BJ": IsoCode.BJ,
    "BL": IsoCode.BL,
    "BM": IsoCode.BM,
    "BN": IsoCode.BN,
    "BO": IsoCode.BO,
    "BQ": IsoCode.BQ,
    "BR": IsoCode.BR,
    "BS": IsoCode.BS,
    "BT": IsoCode.BT,
    "BW": IsoCode.BW,
    "BY": IsoCode.BY,
    "BZ": IsoCode.BZ,
    "CA": IsoCode.CA,
    "CC": IsoCode.CC,
    "CD": IsoCode.CD,
    "CF": IsoCode.CF,
    "CG": IsoCode.CG,
    "CH": IsoCode.CH,
    "CI": IsoCode.CI,
    "CK": IsoCode.CK,
    "CL": IsoCode.CL,
    "CM": IsoCode.CM,
    "CN": IsoCode.CN,
    "CO": IsoCode.CO,
    "CR": IsoCode.CR,
    "CU": IsoCode.CU,
    "CV": IsoCode.CV,
    "CW": IsoCode.CW,
    "CX": IsoCode.CX,
    "CY": IsoCode.CY,
    "CZ": IsoCode.CZ,
    "DE": IsoCode.DE,
    "DJ": IsoCode.DJ,
    "DK": IsoCode.DK,
    "DM": IsoCode.DM,
    "DO": IsoCode.DO,
    "DZ": IsoCode.DZ,
    "EC": IsoCode.EC,
    "EE": IsoCode.EE,
    "EG": IsoCode.EG,
    "EH": IsoCode.EH,
    "ER": IsoCode.ER,
    "ES": IsoCode.ES,
    "ET": IsoCode.ET,
    "FI": IsoCode.FI,
    "FJ": IsoCode.FJ,
    "FK": IsoCode.FK,
    "FM": IsoCode.FM,
    "FO": IsoCode.FO,
    "FR": IsoCode.FR,
    "GA": IsoCode.GA,
    "GB": IsoCode.GB,
    "GD": IsoCode.GD,
    "GE": IsoCode.GE,
    "GF": IsoCode.GF,
    "GG": IsoCode.GG,
    "GH": IsoCode.GH,
    "GI": IsoCode.GI,
    "GL": IsoCode.GL,
    "GM": IsoCode.GM,
    "GN": IsoCode.GN,
    "GP": IsoCode.GP,
    "GQ": IsoCode.GQ,
    "GR": IsoCode.GR,
    "GT": IsoCode.GT,
    "GU": IsoCode.GU,
    "GW": IsoCode.GW,
    "GY": IsoCode.GY,
    "HK": IsoCode.HK,
    "HN": IsoCode.HN,
    "HR": IsoCode.HR,
    "HT": IsoCode.HT,
    "HU": IsoCode.HU,
    "ID": IsoCode.ID,
    "IE": IsoCode.IE,
    "IL": IsoCode.IL,
    "IM": IsoCode.IM,
    "IN": IsoCode.IN,
    "IO": IsoCode.IO,
    "IQ": IsoCode.IQ,
    "IR": IsoCode.IR,
    "IS": IsoCode.IS,
    "IT": IsoCode.IT,
    "JE": IsoCode.JE,
    "JM": IsoCode.JM,
    "JO": IsoCode.JO,
    "JP": IsoCode.JP,
    "KE": IsoCode.KE,
    "KG": IsoCode.KG,
    "KH": IsoCode.KH,
    "KI": IsoCode.KI,
    "KM": IsoCode.KM,
    "KN": IsoCode.KN,
    "KP": IsoCode.KP,
    "KR": IsoCode.KR,
    "KW": IsoCode.KW,
    "KY": IsoCode.KY,
    "KZ": IsoCode.KZ,
    "LA": IsoCode.LA,
    "LB": IsoCode.LB,
    "LC": IsoCode.LC,
    "LI": IsoCode.LI,
    "LK": IsoCode.LK,
    "LR": IsoCode.LR,
    "LS": IsoCode.LS,
    "LT": IsoCode.LT,
    "LU": IsoCode.LU,
    "LV": IsoCode.LV,
    "LY": IsoCode.LY,
    "MA": IsoCode.MA,
    "MC": IsoCode.MC,
    "MD": IsoCode.MD,
    "ME": IsoCode.ME,
    "MF": IsoCode.MF,
    "MG": IsoCode.MG,
    "MH": IsoCode.MH,
    "MK": IsoCode.MK,
    "ML": IsoCode.ML,
    "MM": IsoCode.MM,
    "MN": IsoCode.MN,
    "MO": IsoCode.MO,
    "MP": IsoCode.MP,
    "MQ": IsoCode.MQ,
    "MR": IsoCode.MR,
    "MS": IsoCode.MS,
    "MT": IsoCode.MT,
    "MU": IsoCode.MU,
    "MV": IsoCode.MV,
    "MW": IsoCode.MW,
    "MX": IsoCode.MX,
    "MY": IsoCode.MY,
    "MZ": IsoCode.MZ,
    "NA": IsoCode.NA,
    "NC": IsoCode.NC,
    "NE": IsoCode.NE,
    "NF": IsoCode.NF,
    "NG": IsoCode.NG,
    "NI": IsoCode.NI,
    "NL": IsoCode.NL,
    "NO": IsoCode.NO,
    "NP": IsoCode.NP,
    "NR": IsoCode.NR,
    "NU": IsoCode.NU,
    "NZ": IsoCode.NZ,
    "OM": IsoCode.OM,
    "PA": IsoCode.PA,
    "PE": IsoCode.PE,
    "PF": IsoCode.PF,
    "PG": IsoCode.PG,
    "PH": IsoCode.PH,
    "PK": IsoCode.PK,
    "PL": IsoCode.PL,
    "PM": IsoCode.PM,
    "PR": IsoCode.PR,
    "PS": IsoCode.PS,
    "PT": IsoCode.PT,
    "PW": IsoCode.PW,
    "PY": IsoCode.PY,
    "QA": IsoCode.QA,
    "RE": IsoCode.RE,
    "RO": IsoCode.RO,
    "RS": IsoCode.RS,
    "RU": IsoCode.RU,
    "RW": IsoCode.RW,
    "SA": IsoCode.SA,
    "SB": IsoCode.SB,
    "SC": IsoCode.SC,
    "SD": IsoCode.SD,
    "SE": IsoCode.SE,
    "SG": IsoCode.SG,
    "SH": IsoCode.SH,
    "SI": IsoCode.SI,
    "SJ": IsoCode.SJ,
    "SK": IsoCode.SK,
    "SL": IsoCode.SL,
    "SM": IsoCode.SM,
    "SN": IsoCode.SN,
    "SO": IsoCode.SO,
    "SR": IsoCode.SR,
    "SS": IsoCode.SS,
    "ST": IsoCode.ST,
    "SV": IsoCode.SV,
    "SX": IsoCode.SX,
    "SY": IsoCode.SY,
    "SZ": IsoCode.SZ,
    "TA": IsoCode.TA,
    "TC": IsoCode.TC,
    "TD": IsoCode.TD,
    "TG": IsoCode.TG,
    "TH": IsoCode.TH,
    "TJ": IsoCode.TJ,
    "TK": IsoCode.TK,
    "TL": IsoCode.TL,
    "TM": IsoCode.TM,
    "TN": IsoCode.TN,
    "TO": IsoCode.TO,
    "TR": IsoCode.TR,
    "TT": IsoCode.TT,
    "TV": IsoCode.TV,
    "TW": IsoCode.TW,
    "TZ": IsoCode.TZ,
    "UA": IsoCode.UA,
    "UG": IsoCode.UG,
    "US": IsoCode.US,
    "UY": IsoCode.UY,
    "UZ": IsoCode.UZ,
    "VA": IsoCode.VA,
    "VC": IsoCode.VC,
    "VE": IsoCode.VE,
    "VG": IsoCode.VG,
    "VI": IsoCode.VI,
    "VN": IsoCode.VN,
    "VU": IsoCode.VU,
    "WF": IsoCode.WF,
    "WS": IsoCode.WS,
    "XK": IsoCode.XK,
    "YE": IsoCode.YE,
    "YT": IsoCode.YT,
    "ZA": IsoCode.ZA,
    "ZM": IsoCode.ZM,
    "ZW": IsoCode.ZW,
  };
}