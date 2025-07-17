import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';

class SearchBarView extends StatefulWidget {
  const SearchBarView({super.key});

  @override
  SearchBarViewState createState() => SearchBarViewState();
}

class SearchBarViewState extends State<SearchBarView> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  final controller = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: controller.searchText.value);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
            autocorrect: false,
            controller: _controller,
            focusNode: _focusNode,
            cursorHeight: 15,
            style: const TextStyle(
              color: firstColor,
              fontSize: 11,
              fontWeight: FontWeight.w500
            ),
            onTapOutside: (val) {
              if (val.position.dy < 135 || val.position.dy > 427 || val.position.dx < 20 || (Get.width - val.position.dx) < 20) {
                controller.clearSearch();
              }
            },
            onChanged: controller.search,
            onSaved: (_) => controller.clearSearch(),
            onFieldSubmitted: (_) => controller.clearSearch(),
            onEditingComplete: controller.clearSearch,
            decoration: decorationInput(
              hint: 'Поиск товаров, рецептов, статей',
              prefixIcon: Image.asset('assets/image/search.png'),
              suffixIcon: controller.isAvailable.value ? InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (controller.isListening.value) {
                    controller.stopListening().then((_) {
                      if (context.mounted) {
                        _controller.text = controller.searchText.value;
                      }
                    });
                  } else {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(_focusNode);
                    controller.startListening(_controller, _focusNode, context);
                  }
                },
                child: Image.asset(controller.isListening.value ? 'assets/icon/microphone_active.png' : 'assets/image/microphone.png')
              ) : null
            ),
            textInputAction: TextInputAction.done
        )
    ));
  }
}