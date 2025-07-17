import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/club/recipe_product.dart';
import 'package:rawmid/model/product/product_autocomplete.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/add_news.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';

class AddNewsView extends StatelessWidget {
  const AddNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewsController>(
        init: AddNewsController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                        key: controller.formKey,
                        child: Obx(() => !controller.isLoading.value ? Center(child: CircularProgressIndicator(color: primaryColor)) : CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.nameField,
                                            validator: (value) {
                                              return (value ?? '').isNotEmpty ? null : 'Поле обязательно для заполнения';
                                            },
                                            decoration: decorationInput(hint: 'Название статьи: *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next
                                        ),
                                        h(20),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.videoField,
                                            decoration: decorationInput(hint: 'Ссылка на видео', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next
                                        ),
                                        h(20),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.textField,
                                            maxLines: 6,
                                            decoration: decorationInput(hint: 'Краткое описание', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next
                                        ),
                                        h(20),
                                        Text('Обложка обзора:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        h(10),
                                        Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                  width: Get.width,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(8),
                                                      image: controller.image.isNotEmpty ? DecorationImage(
                                                          image: NetworkImage(controller.image.value),
                                                          fit: BoxFit.cover
                                                      ) : controller.imageFile.value != null ? DecorationImage(
                                                          image: FileImage(controller.imageFile.value!),
                                                          fit: BoxFit.cover
                                                      ) : null
                                                  ),
                                                  child: controller.imageFile.value != null || controller.image.isNotEmpty ? null : Icon(Icons.camera_alt, size: 60, color: Colors.white70)
                                              ),
                                              Positioned(
                                                  bottom: 10,
                                                  left: 15,
                                                  child: FloatingActionButton.small(
                                                      heroTag: 'upload',
                                                      backgroundColor: primaryColor,
                                                      onPressed: controller.pickImage,
                                                      child: Icon(Icons.upload, color: Colors.white)
                                                  )
                                              ),
                                              if (controller.imageFile.value != null || controller.image.isNotEmpty) Positioned(
                                                  bottom: 10,
                                                  right: 15,
                                                  child: FloatingActionButton.small(
                                                      heroTag: 'delete',
                                                      backgroundColor: primaryColor,
                                                      onPressed: () {
                                                        controller.imageFile.value = null;
                                                        controller.image.value = '';
                                                      },
                                                      child: Icon(Icons.delete, color: Colors.white)
                                                  )
                                              )
                                            ]
                                        ),
                                        h(20),
                                        Text('Этапы', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        h(10)
                                      ]
                                  )
                              ),
                              SliverReorderableList(
                                  itemBuilder: (context, index) {
                                    final step = controller.stepFields[index];
                                    final step2 = controller.stepFields2[index];
                                    final image = controller.stepFiles[index];

                                    return Container(
                                        key: ValueKey('step_$index'),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Stack(
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ReorderableDragStartListener(
                                                        index: index,
                                                        child: Icon(Icons.drag_indicator)
                                                    ),
                                                    IconButton(
                                                        onPressed: () => controller.removeStep(index),
                                                        icon: Icon(Icons.close),
                                                        color: Colors.white,
                                                        padding: EdgeInsets.all(10),
                                                        style: IconButton.styleFrom(
                                                            backgroundColor: dangerColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8)
                                                            )
                                                        )
                                                    )
                                                  ]
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 66),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      spacing: 20,
                                                      children: [
                                                        TextFormField(
                                                            cursorHeight: 15,
                                                            controller: step,
                                                            decoration: decorationInput(hint: 'Заголовок*', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            keyboardType: TextInputType.text,
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        TextFormField(
                                                            cursorHeight: 15,
                                                            controller: step2,
                                                            maxLines: 4,
                                                            decoration: decorationInput(hint: 'Текст*', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            keyboardType: TextInputType.text,
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Container(
                                                                  height: 160,
                                                                  width: Get.width,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.grey[200],
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      image: controller.stepFilesStr.elementAtOrNull(index) != null ? DecorationImage(
                                                                          image: NetworkImage(controller.stepFilesStr[index]),
                                                                          fit: BoxFit.cover
                                                                      ) : image.path.isNotEmpty ? DecorationImage(
                                                                          image: FileImage(image),
                                                                          fit: BoxFit.cover
                                                                      ) : null
                                                                  ),
                                                                  child: image.path.isNotEmpty || controller.stepFilesStr.elementAtOrNull(index) != null ? null : Icon(Icons.camera_alt, size: 60, color: Colors.white70)
                                                              ),
                                                              Positioned(
                                                                  bottom: 10,
                                                                  left: 15,
                                                                  child: FloatingActionButton.small(
                                                                      heroTag: 'upload_${index}_1',
                                                                      backgroundColor: primaryColor,
                                                                      onPressed: () => controller.pickImageStep(index),
                                                                      child: Icon(Icons.upload, color: Colors.white)
                                                                  )
                                                              ),
                                                              if (image.path.isNotEmpty || controller.stepFilesStr.elementAtOrNull(index) != null) Positioned(
                                                                  bottom: 10,
                                                                  right: 15,
                                                                  child: FloatingActionButton.small(
                                                                      heroTag: 'delete_${index}_1',
                                                                      backgroundColor: primaryColor,
                                                                      onPressed: () => controller.deleteImage(index),
                                                                      child: Icon(Icons.delete, color: Colors.white)
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                      ]
                                                  )
                                              )
                                            ]
                                        )
                                    );
                                  },
                                  itemCount: controller.stepFields.length,
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex) newIndex -= 1;
                                    final item = controller.stepFields.removeAt(oldIndex);
                                    controller.stepFields.insert(newIndex, item);
                                    final image = controller.stepFiles.removeAt(oldIndex);
                                    controller.stepFiles.insert(newIndex, image);
                                  }
                              ),
                              SliverToBoxAdapter(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (controller.stepFields.isNotEmpty) h(10),
                                        PrimaryButton(text: 'Добавить этап', height: 40, onPressed: controller.adStep),
                                        h(20),
                                        Text('Товары - участники статьи', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        h(10),
                                        TypeAheadField<ProductAutocompleteModel>(
                                            suggestionsCallback: controller.suggestionsCallback,
                                            controller: controller.productField,
                                            itemBuilder: (context, e) => ListTile(title: Text(e.name)),
                                            onSelected: (e) {
                                              controller.products.add(RecipeProductModel(id: e.id, name: e.name));
                                            },
                                            builder: (context, textController, focusNode) {
                                              return TextFormField(
                                                  controller: textController,
                                                  focusNode: focusNode,
                                                  cursorHeight: 15,
                                                  decoration: decorationInput(hint: 'Название товара', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                  textInputAction: TextInputAction.done
                                              );
                                            }
                                        ),
                                        if (controller.products.isNotEmpty) h(20),
                                        if (controller.products.isNotEmpty) Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Color(0xFFDDE8EA)),
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            width: double.infinity,
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                                spacing: 6,
                                                children: List.generate(controller.products.length, (index) {

                                                  return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(controller.products[index].name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                                        ),
                                                        InkWell(
                                                            onTap: () => controller.products.removeAt(index),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[300],
                                                                    borderRadius: BorderRadius.circular(30)
                                                                ),
                                                                padding: EdgeInsets.all(2),
                                                                child: Icon(Icons.close_rounded)
                                                            )
                                                        )
                                                      ]
                                                  );
                                                })
                                            )
                                        ),
                                        h(20),
                                        PrimaryButton(text: 'Сохранить', loader: true, height: 48, onPressed: controller.save),
                                        h(MediaQuery.of(context).padding.bottom)
                                      ]
                                  )
                              )
                            ]
                        ))
                    )
                )
            ))
    );
  }
}