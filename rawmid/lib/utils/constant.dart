import 'package:flutter/material.dart';

const appName = 'Rawmid';
const primaryColor = Color(0xFF14BFFF);
const dangerColor = Color(0xFFF43B4E);
const firstColor = Color(0xFF1E1E1E);
const secondColor = Color(0xFF8A95A8);

var theme = ThemeData(
    fontFamily: 'Manrope',
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: firstColor),
      displayMedium: TextStyle(color: firstColor),
      bodyMedium: TextStyle(color: firstColor),
      titleMedium: TextStyle(color: firstColor),
    )
);

const merchantId = '2c8f4476-a851-429e-89c6-f5ffef02a3f1';
const callbackUrl = 'https://yandex.madeindream.com/yandex-pay/prod/v1/webhook/index.php';
const siteUrl = 'https://madeindream.com';
const apiUrl = '$siteUrl/index.php?route=api/app';
const registerUrl = '$apiUrl/register';
const loginUrl = '$apiUrl/login';
const loginCodeUrl = '$apiUrl/loginCode';
const userUrl = '$apiUrl/getUser';
const editRecipeUrl = '$apiUrl/edit_recipe';
const editSurveyUrl = '$apiUrl/edit_survey';
const getRecipeUrl = '$apiUrl/get_recipe';
const getSurveyUrl = '$apiUrl/get_survey';
const userDeleteUrl = '$apiUrl/user_delete';
const logoutUrl = '$apiUrl/logout';
const sendCodeUrl = '$apiUrl/sendCode';
const changePassUrl = '$apiUrl/changePass';
const setNewsletterUrl = '$apiUrl/changeNewsletter';
const setPushUrl = '$apiUrl/changePush';
const saveUrl = '$apiUrl/save';
const countriesUrl = '$apiUrl/countries';
const rewardsUrl = '$apiUrl/rewards';
const questionsUrl = '$apiUrl/questions';
const setAddressUrl = '$apiUrl/setAddress';
const saveAddressUrl = '$apiUrl/saveAddress';
const deleteAddressUrl = '$apiUrl/deleteAddress';
const uploadAvatarUrl = '$apiUrl/uploadAvatar';
const supportUrl = '$apiUrl/support';
const getWishlistUrl = '$apiUrl/getWishlist';
const comparesUrl = '$apiUrl/compares';
const getBlogUrl = '$apiUrl/blog';
const getCategoriesRecipeUrl = '$apiUrl/getCategoriesRecipe';
const getNewUrl = '$apiUrl/getNew';
const getOrdersUrl = '$apiUrl/orders';
const getOrderUrl = '$apiUrl/orderItem';
const orderCancelUrl = '$apiUrl/orderCancel';
const getBannerUrl = '$apiUrl/banners';
const getRanksUrl = '$apiUrl/getRanks';
const getAchievementsUrl = '$apiUrl/getAchievements';
const getClubUrl = '$apiUrl/getClub';
const getUrlTypeUrl = '$apiUrl/getUrlType';
const saveTokenUrl = '$apiUrl/save_token';
const getFeaturedUrl = '$apiUrl/getFeatured';
const getSernumUrl = '$apiUrl/getSernum';
const getSernumSupportUrl = '$apiUrl/getSernumSupport';
const contactsUrl = '$apiUrl/contacts';
const getOrderIdsUrl = '$apiUrl/getOrderIds';
const getAutocompleteUrl = '$apiUrl/getAutocomplete';
const registerProductUrl = '$apiUrl/registerProduct';
const warrantyProductUrl = '$apiUrl/warrantyProduct';
const getViewedUrl = '$apiUrl/getViewed';
const getRecordsUrl = '$apiUrl/getRecords';
const getNewsUrl = '$apiUrl/getNews';
const getRecipesUrl = '$apiUrl/getRecipes';
const searchUrl = '$apiUrl/search';
const categoriesUrl = '$apiUrl/categories';
const specialUrl = '$apiUrl/specials';
const categoryUrl = '$apiUrl/category';
const loadProductsUrl = '$apiUrl/getFilterProducts';
const loadSpecialProductsUrl = '$apiUrl/specialPage';
const addCartUrl = '$apiUrl/addCart';
const clearUrl = '$apiUrl/clearCart';
const cartProductsUrl = '$apiUrl/getCartProducts';
const getWishlistStrUrl = '$apiUrl/getWishlistStr';
const addWishlistUrl = '$apiUrl/addWishlist';
const updateCartUrl = '$apiUrl/updateCart';
const checkColorsUrl = '$apiUrl/checkColors';
const productUrl = '$apiUrl/product';
const getSerNumUrl = '$apiUrl/getZapSerNum';
const addChainCartUrl = '$apiUrl/addChainCart';
const getDiscountsUrl = '$apiUrl/discounts';
const getAccessoriesUrl = '$apiUrl/accessories';
const getReviewsUrl = '$apiUrl/reviews';
const getMyReviewsUrl = '$apiUrl/my_reviews';
const addQuestionUrl = '$apiUrl/addQuestion';
const addQuestionOtherUrl = '$apiUrl/addQuestionOther';
const addReviewUrl = '$apiUrl/addReview';
const addCommentUrl = '$apiUrl/addComment';
const addQuestionCommentUrl = '$apiUrl/addQuestionComment';
const addXUrl = '$apiUrl/addX';
const getAccProductsUrl = '$apiUrl/getAccProducts';
const getCheckoutUrl = '$apiUrl/checkout';
const getPayStatusUrl = '$apiUrl/getPayStatus';
const setCheckoutUrl = '$apiUrl/setCheckout';
const checkoutUrl = '$apiUrl/order';
const checkout2Url = '$apiUrl/order2';
const changeRegionUrl = '$apiUrl/changeRegion';
const bbPvzUrl = '$siteUrl/index.php?route=checkout/bb/select_pvz';
const getBbPvzUrl = '$siteUrl/index.php?route=checkout/bb/getPvzMapPoints';
const ocoXUrl = '$apiUrl/osobie';
const paymentUrl = '$apiUrl/payment';
const personalDataUrl = '$siteUrl/informatsija/politika-obrabotki.html?ajax=1';
const uslUrl = '$siteUrl/index.php?route=record/record&ajax=1&record_id=104';
const searchCityUrl = '$siteUrl/index.php?route=module/geoip/search&term=';