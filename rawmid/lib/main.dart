import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/auth/login.dart';
import 'package:rawmid/screen/auth/login_code.dart';
import 'package:rawmid/screen/auth/register.dart';
import 'package:rawmid/screen/checkout/checkout.dart';
import 'package:rawmid/screen/club/achieviment.dart';
import 'package:rawmid/screen/club/content.dart';
import 'package:rawmid/screen/compare.dart';
import 'package:rawmid/screen/main.dart';
import 'package:rawmid/screen/news/blog.dart';
import 'package:rawmid/screen/special.dart';
import 'package:rawmid/screen/support/support.dart';
import 'package:rawmid/screen/order/order.dart';
import 'package:rawmid/screen/user/add_news.dart';
import 'package:rawmid/screen/user/add_product.dart';
import 'package:rawmid/screen/user/add_recept.dart';
import 'package:rawmid/screen/user/my_product.dart';
import 'package:rawmid/screen/user/reviews.dart';
import 'package:rawmid/screen/user/reward.dart';
import 'package:rawmid/screen/user/user.dart';
import 'package:rawmid/screen/user/warranty_product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rawmid/utils/notifications.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Future.delayed(Duration(seconds: 4), () {
    NotificationsService.start();
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Helper.initialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/home', page: () => const MainView()),
          GetPage(name: '/register', page: () => const RegisterView()),
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/login_code', page: () => const LoginCodeView()),
          GetPage(name: '/user', page: () => const UserView()),
          GetPage(name: '/checkout', page: () => const CheckoutView()),
          GetPage(name: '/reviews', page: () => const MyReviewsView()),
          GetPage(name: '/blog', page: () => const BlogView()),
          GetPage(name: '/support', page: () => const SupportView()),
          GetPage(name: '/orders', page: () => const OrderView()),
          GetPage(name: '/compare', page: () => const CompareView()),
          GetPage(name: '/club_content', page: () => const ClubContentView()),
          GetPage(name: '/achieviment', page: () => const AchievimentView()),
          GetPage(name: '/specials', page: () => const SpecialView()),
          GetPage(name: '/my_products', page: () => const MyProductView()),
          GetPage(name: '/add_product', page: () => const AddProductView()),
          GetPage(name: '/warranty_product', page: () => const WarrantyProductView()),
          GetPage(name: '/rewards', page: () => const RewardView()),
          GetPage(name: '/add_recipe', page: () => const AddReceptView()),
          GetPage(name: '/add_news', page: () => const AddNewsView()),
        ],
        locale: Locale('ru', 'RU'),
        supportedLocales: [
          Locale('ru', 'RU')
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        builder: (context, child) {
          final size = MediaQuery.of(context).size;
          final width = size.width;
          final height = size.height;

          final tabBarHeight = 56.0;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          final tabBarTotalHeight = tabBarHeight + bottomPadding;

          final mobileWidth = 380.0;
          final mobileHeight = 640.0;
          final availableHeight = height - tabBarTotalHeight;

          final scaleWidth = width / mobileWidth;
          final scaleHeight = availableHeight / mobileHeight;
          final scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;

          final other = Center(
              child: Transform.scale(
                  scale: scale,
                  child: SizedBox(
                      width: mobileWidth,
                      height: mobileHeight,
                      child: child
                  )
              )
          );

          return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                  return other;
                }

                if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                  return other;
                }

                return child!;
              }
          );
        },
        theme: theme,
        debugShowCheckedModeBanner: false,
        title: appName
    );
  }
}