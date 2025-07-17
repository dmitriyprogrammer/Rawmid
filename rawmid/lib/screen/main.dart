import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/widget/menu.dart';
import '../controller/navigation.dart';
import '../widget/nav_menu.dart';
import '../widget/w.dart';
import 'home/city.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, this.index});

  final int? index;

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  late NavigationController controller;

  @override
  void initState() {
    super.initState();
    Get.put(NavigationController());
    controller = Get.find<NavigationController>();
    controller.tabController = TabController(length: controller.widgetOptions.length, vsync: this, initialIndex: widget.index ?? 0);
  }

  @override
  void dispose() {
    controller.tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int act = controller.tabController?.index ?? 0;

      if (widget.index != null) {
        act = widget.index!;
      }

      return PopScope(
          canPop: false,
          onPopInvokedWithResult: (type, val) async {
            if (!type && controller.tabController!.index != 0) {
              controller.tabController!.index = 0;
              controller.activeTab.value = 0;
              return;
            }

            Future.microtask(() {
              Get.back();
            });
          },
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: DefaultTabController(
                  length: controller.widgetOptions.length,
                  initialIndex: act,
                  child: Scaffold(
                      appBar: AppBar(
                          titleSpacing: 20,
                          leading: SizedBox.shrink(),
                          leadingWidth: 0,
                          title: ClipRect(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        children: [
                                          Builder(
                                              builder: (context) => InkWell(
                                                  onTap: () {
                                                    Scaffold.of(context).openDrawer();
                                                  },
                                                  child: Image.asset('assets/icon/burger.png')
                                              )
                                          ),
                                          w(26),
                                          Image.asset('assets/image/logo.png', width: 70)
                                        ]
                                    ),
                                    if (controller.city.value.isNotEmpty) w(10),
                                    if (controller.city.value.isNotEmpty) Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: Get.context!,
                                                  isScrollControlled: true,
                                                  useSafeArea: true,
                                                  useRootNavigator: true,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                  ),
                                                  builder: (context) {
                                                    return CitySearch();
                                                  }
                                              ).then((_) {
                                                controller.filteredCities.value = controller.cities;
                                                controller.filteredLocation.clear();
                                              });
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 30),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                                                      w(6),
                                                      Flexible(
                                                          child: Text(
                                                              controller.city.value,
                                                              textAlign: TextAlign.right,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Color(0xFF14BFFF),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600
                                                              )
                                                          )
                                                      )
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                      ),
                      body: TabBarView(
                          controller: controller.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.widgetOptions
                      ),
                      drawer: MenuView(controller: controller),
                      backgroundColor: Color(0xFFF0F0F0),
                      bottomNavigationBar: NavMenuView()
                  )
              )
          )
      );
    });
  }
}