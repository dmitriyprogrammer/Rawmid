import 'package:flutter/material.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/helper.dart';
import 'package:get/get.dart';

class WebViewWithSession extends StatefulWidget {
  const WebViewWithSession({super.key, required this.link});

  final String link;

  @override
  WebViewWithSessionState createState() => WebViewWithSessionState();
}

class WebViewWithSessionState extends State<WebViewWithSession> {
  late WebViewController _controller;
  final ScreenshotController screenshotController = ScreenshotController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWebPage();
  }

  void _injectCookies() async {
    String jsCode = "document.cookie = 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}; path=/; domain=.${siteUrl.replaceAll('https://', '')}';";
    await _controller.runJavaScript(jsCode);
    await Future.delayed(Duration(seconds: 1));
    _captureAndConvert();
  }

  void _loadWebPage() async {
    final link = Uri.parse(widget.link);

    final cookieManager = WebViewCookieManager();

    await cookieManager.setCookie(
        WebViewCookie(
            name: 'PHPSESSID',
            value: Helper.prefs.getString('PHPSESSID') ?? '',
            domain: link.host,
            path: '/'
        )
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            _injectCookies();
          }
      ));

    await _controller.loadRequest(Uri.parse(widget.link), headers: {'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'});
  }

  Future<void> _captureAndConvert() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    Uint8List? screenshot = await screenshotController.capture();

    if (screenshot != null) {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Image(pw.MemoryImage(screenshot))
          )
        )
      );

      Uint8List pdfData = await pdf.save();
      await Printing.layoutPdf(onLayout: (format) => pdfData);
    }
  }

  Future<void> generateAndPrintPdf(String html) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('HTML Content\n$html')
        )
      )
    );

    Uint8List pdfData = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (format) async => pdfData
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          title: Padding(
              padding: const EdgeInsets.only(left: 4, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: Get.back,
                        icon: Image.asset('assets/icon/left.png')
                    ),
                    Image.asset('assets/image/logo.png', width: 70)
                  ]
              )
          )
      ),
      bottomSheet: !isLoading ? Center(child: CircularProgressIndicator(color: primaryColor)) : Screenshot(controller: screenshotController, child: WebViewWidget(controller: _controller))
    );
  }
}