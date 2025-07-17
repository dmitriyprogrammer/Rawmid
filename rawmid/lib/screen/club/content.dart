import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/screen/user/reviews.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/club.dart';
import '../../model/product/review.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';
import '../home/news.dart';
import '../home/recipies.dart';

class ClubContentView extends GetView<ClubController> {
  const ClubContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClubController>(
        init: ClubController(),
        builder: (club) => Scaffold(
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
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Obx(() => club.isLoading.value ? SingleChildScrollView(
                    child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ColoredBox(
                                    color: Color(0xFFF0F0F0),
                                    child: Column(
                                        children: [
                                          h(20),
                                          SearchBarView(),
                                          h(20)
                                        ]
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          h(16),
                                          Text(
                                              'Мой контент',
                                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                if (controller.reviews.isNotEmpty) Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      h(20),
                                      Column(
                                          children: [
                                            h(30),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10, right: 20),
                                              child: ModuleTitle(title: 'Отзывы', type: true, callback: () => Get.to(() => MyReviewsView()))
                                            ),
                                            h(10),
                                            SizedBox(
                                                width: Get.width,
                                                height: controller.isChecked.value == controller.activeReviewsIndex.value ? 215 + controller.revHeight.value : 223,
                                                child: PageView.builder(
                                                    controller: controller.reviewsController,
                                                    itemCount: controller.reviews.length,
                                                    onPageChanged: (index) {
                                                      controller.activeReviewsIndex.value = index;
                                                      final rev = controller.reviews[index];

                                                      if (!rev.checked) {
                                                        controller.revHeight.value = 0;
                                                      }
                                                    },
                                                    clipBehavior: Clip.none,
                                                    padEnds: false,
                                                    itemBuilder: (context, index) {
                                                      return Obx(() => _buildReviewCard(controller.reviews[index], index));
                                                    }
                                                )
                                            ),
                                            if (controller.reviews[controller.activeReviewsIndex.value].product != null) h(10),
                                            if (controller.reviews[controller.activeReviewsIndex.value].product != null) Padding(
                                              padding: EdgeInsets.only(right: 20, left: 10),
                                              child: PrimaryButton(text: 'Оставить отзыв', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
                                                showModalBottomSheet(
                                                    context: Get.context!,
                                                    isScrollControlled: true,
                                                    useSafeArea: true,
                                                    useRootNavigator: true,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                    ),
                                                    builder: (context) {
                                                      return _openReview(controller.reviews[controller.activeReviewsIndex.value].product!);
                                                    }
                                                );
                                              })
                                            ),
                                            h(10)
                                          ]
                                      )
                                    ]
                                  )
                                ),
                                if (controller.recipes.isNotEmpty) RecipesSection(recipes: controller.recipes, my: 0, padding: EdgeInsets.symmetric(horizontal: 12), button: false, title: 'Мои рецепты', callback: () {
                                  Get.toNamed('/blog', arguments: true, parameters: {'my_recipes': '1', 'my': '0'});
                                }, callback2: () => controller.initialize()),
                                h(16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: PrimaryButton(text: 'Написать рецепт', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () => Get.toNamed('/add_recipe')?.then((_) => controller.initialize()))
                                ),
                                if (controller.news.isNotEmpty) h(16),
                                if (controller.news.isNotEmpty) Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: NewsSection(news: controller.news, survey: true, my: 1, title: 'Мои обзоры', callback: () {
                                    Get.toNamed('/blog', parameters: {'my_survey': '1', 'my': '1'});
                                  }, callback2: () => controller.initialize())
                                ),
                                if (controller.news.isNotEmpty) h(16),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: PrimaryButton(text: 'Написать статью', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () => Get.toNamed('/add_news')?.then((_) => controller.initialize()))
                                ),
                                h(20 + MediaQuery.of(context).viewPadding.bottom),
                              ]
                          ),
                          SearchWidget()
                        ]
                    )) : Center(
                    child: CircularProgressIndicator(color: primaryColor)
                ))
            )
        )
    );
  }

  Widget _buildReviewCard(ReviewModel review, int index) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              useSafeArea: true,
              useRootNavigator: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
              builder: (context) {
                return _openComments(review);
              }
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            spacing: 16,
            children: [
              if (review.product != null) SizedBox(
                height: 48,
                child: GestureDetector(
                  onTap: () => Get.to(() => ProductView(id: review.product!.id)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                imageUrl: review.product!.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover
                            )
                        ),
                        Expanded(
                            child: Row(
                                spacing: 16,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                          review.product!.title,
                                          style: TextStyle(
                                              color: const Color(0xFF1E1E1E),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700
                                          )
                                      )
                                  ),
                                  Text(
                                      '1 500 ₽',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: const Color(0xFF1E1E1E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700
                                      )
                                  )
                                ]
                            )
                        )
                      ]
                  )
                )
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              review.author,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          h(20),
                          Row(
                              children: [
                                if (review.rating > 0) Row(
                                    children: [1,2,3,4,5].map((e) => Icon(e <= review.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                ),
                                if (review.rating > 0) w(5),
                                if (review.rating > 0) Text(
                                    '${review.rating}',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                ),
                                if (review.date != null) Spacer(),
                                if (review.date != null) Text(controller.formatDateCustom(review.date!), style: TextStyle(color: Colors.grey))
                              ]
                          ),
                          h(10),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Stack(
                                            children: [
                                              Text(review.text, style: TextStyle(), maxLines: review.checked && controller.isChecked.value == index ? null : 3, overflow: review.checked && controller.isChecked.value == index ? null : TextOverflow.ellipsis),
                                              if (review.text.length > 200 && !review.checked) Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: InkWell(
                                                      onTap: () {
                                                        review.checked = !review.checked;
                                                        controller.revHeight.value = Helper.getTextHeight(review.text, TextStyle(), Get.width - 20);

                                                        if (review.checked) {
                                                          controller.isChecked.value = index;
                                                        } else {
                                                          controller.isChecked.value = -1;
                                                        }
                                                      },
                                                      child: Container(
                                                          padding: const EdgeInsets.only(left: 3),
                                                          color: Colors.white,
                                                          child: Text(
                                                              'читать далее...',
                                                              style: TextStyle(color: Colors.blue, fontSize: 14)
                                                          )
                                                      )
                                                  )
                                              )
                                            ]
                                        )
                                    ),
                                    if (review.checked) InkWell(
                                        onTap: () {
                                          review.checked = false;
                                          controller.isChecked.value = -1;
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(left: 3),
                                            color: Colors.white,
                                            child: Text(
                                                'Свернуть',
                                                style: TextStyle(color: Colors.blue, fontSize: 14)
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                )
              )
            ]
          )
        )
    );
  }


  Widget _openComments(ReviewModel review) {
    return SizedBox(
        height: Get.height * 0.8,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: 16, right: 16, top: 40, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      review.author,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                      )
                                  ),
                                  h(10),
                                  if (review.rating > 0) Row(
                                      children: [
                                        Row(
                                            children: [1,2,3,4,5].map((e) => Icon(e <= review.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                        ),
                                        w(5),
                                        Text(
                                            '${review.rating}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                        )
                                      ]
                                  )
                                ]
                            )
                        ),
                        if (review.date != null) Text(
                            controller.formatDateCustom(review.date!),
                            style: TextStyle(
                                color: Color(0xFF8A95A8),
                                fontSize: 11
                            )
                        )
                      ]
                  ),
                  h(16),
                  Text(
                      review.text,
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 14,
                          height: 1.40
                      )
                  ),
                  h(32),
                  if (review.comments.isNotEmpty) Wrap(
                      runSpacing: 12,
                      children: List.generate(review.comments.length, (index) {
                        final item = review.comments[index];

                        return !item.parent ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                                color: Color(0x4CF0F0F0),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                    borderRadius: BorderRadius.circular(6)
                                )
                            ),
                            child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: Row(
                                                children: [
                                                  Image.asset('assets/icon/chat.png', width: 16),
                                                  w(6),
                                                  Text(
                                                      item.author,
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      )
                                                  )
                                                ]
                                            )
                                        ),
                                        if (item.date != null) Text(
                                            controller.formatDateCustom(item.date!),
                                            style: TextStyle(
                                                color: Color(0xFF8A95A8),
                                                fontSize: 11
                                            )
                                        )
                                      ]
                                  ),
                                  h(16),
                                  Text(
                                      item.text,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 14,
                                          height: 1.40
                                      )
                                  )
                                ]
                            )
                        ) : Text(
                            item.text,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 14,
                                height: 1.40
                            )
                        );
                      })
                  ),
                  if (review.product != null) h(20),
                  if (review.product != null) PrimaryButton(text: 'Оставить комментарий', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
                    controller.isComment.value = review.id;
                    Get.back();

                    showModalBottomSheet(
                        context: Get.context!,
                        isScrollControlled: true,
                        useSafeArea: true,
                        useRootNavigator: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        builder: (context) {
                          return _openReview(review.product!);
                        }
                    );
                  }),
                  h(20)
                ]
            )
        )
    );
  }

  Widget _openReview(ProductModel product) {
    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      controller.isComment.isNotEmpty || controller.isQuestionComment.isNotEmpty ? 'Оставьте комментарий' : 'Оставьте отзыв',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  if (controller.isComment.isEmpty && controller.isQuestionComment.isEmpty || controller.isQuestionComment.isEmpty && controller.isComment.isEmpty) h(16),
                  if (controller.isComment.isEmpty && controller.isQuestionComment.isEmpty || controller.isQuestionComment.isEmpty && controller.isComment.isEmpty) Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                imageUrl: product.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover
                            )
                        ),
                        w(12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      product.title,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700
                                      )
                                  ),
                                  if (product.color.isNotEmpty) Text(
                                      'Цвет: ${product.color}',
                                      style: TextStyle(
                                          color: Color(0xFF8A95A8),
                                          fontSize: 10
                                      )
                                  )
                                ]
                            )
                        ),
                        w(12),
                        Text(
                            ((product.special ?? '').isNotEmpty ? product.special : product.price) ?? '',
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  ),
                  if (controller.isQuestionComment.isEmpty) h(20),
                  if (controller.isQuestionComment.isEmpty) Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(Icons.star, color: index < controller.rating.value ? Colors.amber : Color(0x4CFFCC00), size: 40),
                          onPressed: () => controller.rating.value = index+1,
                          padding: EdgeInsets.zero,
                        );
                      })
                  ),
                  h(20),
                  TextFormField(
                      cursorHeight: 15,
                      controller: controller.fioReviewField,
                      decoration: decorationInput(hint: 'Имя', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваше ФИО';
                        }

                        return null;
                      }
                  ),
                  h(10),
                  if (controller.user.value == null) TextFormField(
                      controller: controller.emailReviewField,
                      cursorHeight: 15,
                      decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.validateEmailX,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите E-mail';
                        } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                          return 'E-mail заполнен некорректно';
                        }

                        return null;
                      }
                  ),
                  if (controller.user.value == null && controller.emailValidate.value) Padding(
                      padding: const EdgeInsets.only(top: 4, left: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'E-mail не существует',
                                style: TextStyle(color: dangerColor, fontSize: 12)
                            )
                          ]
                      )
                  ),
                  if (controller.user.value == null) h(10),
                  TextFormField(
                      controller: controller.textReviewField,
                      decoration: decorationInput(hint: 'Текст', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      cursorHeight: 15,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваш отзыв';
                        }

                        return null;
                      }
                  ),
                  h(20),
                  PrimaryButton(text: controller.isComment.isNotEmpty || controller.isQuestionComment.isNotEmpty ? 'Отправить комментарий' : 'Опубликовать отзыв', loader: true, height: 50, onPressed: () => controller.addReview(product.id)),
                  h(20)
                ]
            ))
        )
    );
  }
}