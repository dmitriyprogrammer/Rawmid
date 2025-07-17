import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/club/recipe_product.dart';
import 'package:rawmid/model/product/product_autocomplete.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/add_recept.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/select.dart';

class AddReceptView extends StatelessWidget {
  const AddReceptView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddReceptController>(
        init: AddReceptController(),
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
                                      decoration: decorationInput(hint: 'Название рецепта: *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
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
                                  SelectDropDown(
                                      hint: 'Тип',
                                      values: [
                                        'Традиционное',
                                        'Вегетарианство',
                                        'Веганство',
                                        'Сыроедение'
                                      ],
                                      selected: controller.types,
                                      callback: (val, index) {
                                        controller.types.value = val;
                                        controller.update();
                                      }
                                  ),
                                  h(20),
                                  TextFormField(
                                      cursorHeight: 15,
                                      controller: controller.textField,
                                      maxLines: 6,
                                      decoration: decorationInput(hint: 'Описание', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next
                                  ),
                                  h(20),
                                  Text('Обложка рецепта:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('КБЖУ и Ингредиенты', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                            h(10),
                                            Row(
                                                spacing: 8,
                                                children: [
                                                  Expanded(
                                                      child: TextFormField(
                                                          cursorHeight: 15,
                                                          controller: controller.bField,
                                                          decoration: decorationInput(hint: 'Белки*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next
                                                      )
                                                  ),
                                                  Expanded(
                                                      child: TextFormField(
                                                          cursorHeight: 15,
                                                          controller: controller.zField,
                                                          decoration: decorationInput(hint: 'Жиры*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next
                                                      )
                                                  ),
                                                  Expanded(
                                                      child: TextFormField(
                                                          cursorHeight: 15,
                                                          controller: controller.uField,
                                                          decoration: decorationInput(hint: 'Углеводы*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next
                                                      )
                                                  ),
                                                  Expanded(
                                                      child: TextFormField(
                                                          cursorHeight: 15,
                                                          controller: controller.kField,
                                                          decoration: decorationInput(hint: 'Ккал*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next
                                                      )
                                                  )
                                                ]
                                            ),
                                            h(10),
                                            Divider(thickness: 1, color: Colors.white),
                                            if (controller.ingredients.isNotEmpty) h(10),
                                            ...controller.ingredients.asMap().entries.map((entry) {
                                              int index = entry.key;
                                              var controllers = entry.value;

                                              return Padding(
                                                  padding: const EdgeInsets.only(bottom: 16),
                                                  child: Row(
                                                      spacing: 8,
                                                      children: [
                                                        Expanded(
                                                            child: TextFormField(
                                                                cursorHeight: 15,
                                                                controller: controllers['name']!,
                                                                validator: (value) {
                                                                  return (value ?? '').isNotEmpty ? null : 'Поле обязательно для заполнения';
                                                                },
                                                                decoration: decorationInput(hint: 'Ингредиент*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                keyboardType: TextInputType.text,
                                                                textInputAction: TextInputAction.next
                                                            )
                                                        ),
                                                        Expanded(
                                                            child: TextFormField(
                                                                cursorHeight: 15,
                                                                controller: controllers['text']!,
                                                                validator: (value) {
                                                                  return (value ?? '').isNotEmpty ? null : 'Поле обязательно для заполнения';
                                                                },
                                                                decoration: decorationInput(hint: 'Количество*', contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                keyboardType: TextInputType.text,
                                                                textInputAction: TextInputAction.next
                                                            )
                                                        ),
                                                        IconButton(
                                                            onPressed: () => controller.removeIngredient(index),
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
                                                  )
                                              );
                                            }),
                                            if (controller.ingredients.isNotEmpty) h(10),
                                            PrimaryButton(text: 'Добавить ингредиент', height: 40, onPressed: controller.addIngredient)
                                          ]
                                      )
                                  ),
                                  h(20),
                                  Text('Шаги', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  h(10)
                                ]
                            )
                          ),
                          SliverReorderableList(
                            itemBuilder: (context, index) {
                              final step = controller.stepFields[index];
                              final image = controller.stepFiles['image1_$index'];
                              final image2 = controller.stepFiles['image2_$index'];

                              return Container(
                                  key: ValueKey('step_$index'),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  padding: EdgeInsets.all(20),
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
                                                      maxLines: 4,
                                                      decoration: decorationInput(hint: 'Текст*', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.next
                                                  ),
                                                  Row(
                                                      spacing: 10,
                                                      children: [
                                                        Expanded(
                                                            child: Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Container(
                                                                      height: 160,
                                                                      width: (Get.width - 40) / 2,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey[200],
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          image: controller.stepFilesStr.containsKey('image1_$index') ? DecorationImage(
                                                                              image: NetworkImage(controller.stepFilesStr['image1_$index']!),
                                                                              fit: BoxFit.cover
                                                                          ) : (image?.path ?? '').isNotEmpty ? DecorationImage(
                                                                              image: FileImage(image!),
                                                                              fit: BoxFit.cover
                                                                          ) : null
                                                                      ),
                                                                      child: (image?.path ?? '').isNotEmpty || controller.stepFilesStr.containsKey('image1_$index') ? null : Icon(Icons.camera_alt, size: 60, color: Colors.white70)
                                                                  ),
                                                                  Positioned(
                                                                      bottom: 10,
                                                                      left: 15,
                                                                      child: FloatingActionButton.small(
                                                                          heroTag: 'upload_${index}_1',
                                                                          backgroundColor: primaryColor,
                                                                          onPressed: () => controller.pickImageStep(index, 'image1'),
                                                                          child: Icon(Icons.upload, color: Colors.white)
                                                                      )
                                                                  ),
                                                                  if ((image?.path ?? '').isNotEmpty || controller.stepFilesStr.containsKey('image1_$index')) Positioned(
                                                                      bottom: 10,
                                                                      right: 15,
                                                                      child: FloatingActionButton.small(
                                                                          heroTag: 'delete_${index}_1',
                                                                          backgroundColor: primaryColor,
                                                                          onPressed: () => controller.deleteImage(index, 'image1'),
                                                                          child: Icon(Icons.delete, color: Colors.white)
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                        Expanded(
                                                            child: Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Container(
                                                                      height: 160,
                                                                      width: (Get.width - 40) / 2,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey[200],
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          image: controller.stepFilesStr.containsKey('image2_$index') ? DecorationImage(
                                                                              image: NetworkImage(controller.stepFilesStr['image2_$index']!),
                                                                              fit: BoxFit.cover
                                                                          ) : (image2?.path ?? '').isNotEmpty ? DecorationImage(
                                                                              image: FileImage(image2!),
                                                                              fit: BoxFit.cover
                                                                          ) : null
                                                                      ),
                                                                      child: (image2?.path ?? '').isNotEmpty || controller.stepFilesStr.containsKey('image2_$index') ? null : Icon(Icons.camera_alt, size: 60, color: Colors.white70)
                                                                  ),
                                                                  Positioned(
                                                                      bottom: 10,
                                                                      left: 15,
                                                                      child: FloatingActionButton.small(
                                                                          heroTag: 'upload2_${index}_1',
                                                                          backgroundColor: primaryColor,
                                                                          onPressed: () => controller.pickImageStep(index, 'image2'),
                                                                          child: Icon(Icons.upload, color: Colors.white)
                                                                      )
                                                                  ),
                                                                  if ((image2?.path ?? '').isNotEmpty || controller.stepFilesStr.containsKey('image2_$index')) Positioned(
                                                                      bottom: 10,
                                                                      right: 15,
                                                                      child: FloatingActionButton.small(
                                                                          heroTag: 'delete2_${index}_1',
                                                                          backgroundColor: primaryColor,
                                                                          onPressed: () => controller.deleteImage(index, 'image2'),
                                                                          child: Icon(Icons.delete, color: Colors.white)
                                                                      )
                                                                  )
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
                              );
                            },
                            itemCount: controller.stepFields.length,
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > oldIndex) newIndex -= 1;
                              final item = controller.stepFields.removeAt(oldIndex);
                              controller.stepFields.insert(newIndex, item);
                              final image1 = controller.stepFiles.remove('image1_$oldIndex');
                              controller.insertToMap(controller.stepFiles, oldIndex, 'image1_$newIndex', image1);
                              final image2 = controller.stepFiles.remove('image2_$oldIndex');
                              controller.insertToMap(controller.stepFiles, oldIndex, 'image2_$newIndex', image2);
                            }
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller.stepFields.isNotEmpty) h(10),
                                PrimaryButton(text: 'Добавить шаг', height: 40, onPressed: controller.adStep),
                                if (controller.categories.isNotEmpty) h(20),
                                if (controller.categories.isNotEmpty) Text('Категория', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                if (controller.categories.isNotEmpty) h(20),
                                if (controller.categories.isNotEmpty) SelectDropDown(
                                    hint: 'Категория',
                                    values: controller.categories.map((e) => e.name).toList(),
                                    selected: controller.categoriesSelect,
                                    callback: (val, index) {
                                      controller.categoriesSelect.value = val;
                                    }
                                ),
                                h(20),
                                TextFormField(
                                    cursorHeight: 15,
                                    controller: controller.tegField,
                                    decoration: decorationInput(hint: 'Теги', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next
                                ),
                                h(20),
                                Text('Товары - участники рецепта', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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