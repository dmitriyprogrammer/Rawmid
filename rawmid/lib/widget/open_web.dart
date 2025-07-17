import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widget/h.dart';
import '../api/checkout.dart';
import '../utils/helper.dart';

class OpenWebView extends StatefulWidget {
  const OpenWebView({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<OpenWebView> createState() => OpenWebViewState();
}

class OpenWebViewState extends State<OpenWebView> {
  WebViewController? webController;
  bool isPayLoad = false;
  bool initV = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    if (widget.url.contains('order_id')) {
      final u = Uri.parse(widget.url);
      await getPayStatus(u.queryParameters['order_id'] ?? '', fix: true);
    }
  }

  Future<void> _initializeWebView() async {
    if (initV) return;
    var url = widget.url;
    var orderId = '';

    if (url.contains('order_id')) {
      final u = Uri.parse(url);
      orderId = u.queryParameters['order_id'] ?? '';
      getPayStatus(orderId);
      url = '$paymentUrl&app_pay=1&order_id=$orderId';
    }

    webController = WebViewController()
      ..addJavaScriptChannel(
          'ErrorChannel',
          onMessageReceived: (message) {
            debugPrint('JavaScript Error: ${message.message}');
          }
      )
      ..setNavigationDelegate(
          NavigationDelegate(
              onPageFinished: (String url) {
                _injectErrorCatcher();
              },
              onNavigationRequest: (NavigationRequest request) async {
                if (request.url.contains('checkout/success')) {
                  Helper.snackBar(text: 'Ваш заказ успешно оплачен');
                  return NavigationDecision.prevent;
                }

                if (request.url.contains('tinkof_url_app=')) {
                  final uri = Uri.parse(request.url);
                  webController?.loadRequest(Uri.parse(uri.queryParameters['tinkof_url_app'] ?? ''));
                  return NavigationDecision.prevent;
                }

                if (request.url.startsWith('http') || request.url.startsWith('https')) {
                  getPayStatus(orderId);
                  return NavigationDecision.navigate;
                } else {
                  final uri = Uri.parse(request.url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    Helper.snackBar(error: true, text: 'Приложение выбранного банка не найдено на вашем устройстве', callback: () {
                      Get.back();
                    });
                  }

                  return NavigationDecision.prevent;
                }
              }
          )
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  Future getPayStatus(String id, {bool fix = false}) async {
    if (fix) {
      initV = true;
    }

    final api = await CheckoutApi.getPayStatus(id);

    if (api) {
      if (fix) {
        Get.back();
      }

      Helper.snackBar(text: 'Ваш заказ успешно оплачен');
    } else if (fix) {
      _initializeWebView();
    }
  }

  void _injectErrorCatcher() async {
    await webController?.runJavaScript('''
    (function() {
      var oldConsoleError = console.error;
      console.error = function(message) {
        ErrorChannel.postMessage("Ошибка в консоли: " + message);
        oldConsoleError.apply(console, arguments);
      };

      window.addEventListener('error', function(event) {
        ErrorChannel.postMessage("Ошибка: " + event.message + 
          "\\nИсточник: " + event.filename + 
          "\\nСтрока: " + event.lineno + 
          " Колонка: " + event.colno + 
          "\\n" + (event.error ? event.error.stack : ""));
      });

      window.addEventListener('unhandledrejection', function(event) {
        ErrorChannel.postMessage("Unhandled Promise Rejection: " + event.reason);
      });
    })();
  ''');

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isPayLoad = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isPayLoad) {
      _initializeWebView();
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        height: Get.height * 0.8,
        clipBehavior: Clip.antiAlias,
        child: Stack(
            children: [
              Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                            mainAxisAlignment: widget.title.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                            children: [
                              if (widget.title.isNotEmpty) Text(
                                  widget.title,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                              IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: Get.back
                              )
                            ]
                        )
                    ),
                    if (widget.title.isNotEmpty) const Divider(height: 1),
                    h(16),
                    if (webController != null) Expanded(
                        child: Container(
                            color: Colors.transparent,
                            child: WebViewWidget(
                                controller: webController!
                            )
                        )
                    )
                  ]
              ),
              if (!isPayLoad) Container(alignment: Alignment.center, color: Colors.white, width: Get.width, height: Get.height, child: CircularProgressIndicator(color: primaryColor))
            ]
        )
    );
  }
}