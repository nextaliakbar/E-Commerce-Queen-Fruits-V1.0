class AppConstants {
  static const String appName = 'Queen Fruits';
  static const String baseUrl = 'http://localhost:8000';
  static const String policyPage = '/api/v1/pages'; // incoming
  static const String tokenUri = '/api/customer/cm-firebase-token'; // incoming
  static const String subscribeToTopic = '/api/v1/fcm-subscribe-to-topic';
  static const String customerInfoUri = '/api/v1/customer/info'; // completed
  static const String categoryUri = '/api/v1/categories'; // completed
  static const String getDeliveryInfo = '/api/v1/config/delivery-fee'; // completed
  static const String configUri = '/api/v1/config'; // completed
  static const String searchSuggestion = '/api/v1/products/search-suggestion';
  static const String wishListGetUri = '/api/v1/customer/wish-list';
  static const String latestProductUri = '/api/v1/products/latest'; // completed
  static const String popularProductUri = '/api/v1/products/popular'; // completed
  static const String importProductUri = '/api/v1/products/import-product'; // completed
  static const String recommendedProductUri = '/api/v1/products/recommended'; // completed
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String bannerUri = '/api/v1/banners'; // completed
  static const String searchRecommended = '/api/v1/products/search-recommended'; // completed
  static const String frequentlyBought = '/api/v1/products/frequently-bought'; // incoming
  static const String subCategoryUri = '/api/v1/categories/childes/'; // completed
  static const String categoryProductUri = '/api/v1/categories/products/'; // completed
  static const String searchUri = '/api/v1/products/search'; // incoming
  static const String loginUri = '/api/v1/auth/login'; // completed
  static const String registerUri = '/api/v1/auth/registration'; // completed
  static const String addressListUri = '/api/v1/customer/address/list'; // completed
  static const String addAddressUri = '/api/v1/customer/address/add'; // completed
  static const String offlinePaymentMethod = '/api/v1/offline-payment-method/list'; // completed
  static const String lastOrderedAddress = '/api/v1/customer/last-ordered-address'; // completed
  static const String distanceMatrixUri = '/api/v1/mapapi/distance-api'; // completed
  static const String placeOrderUri = '/api/v1/customer/order/place'; // completed with bug in server
  static const String orderListUri = '/api/v1/customer/order/list'; // completed
  static const String orderDetailsUri = '/api/v1/customer/order/details?order_id=';

  // Shared key
  static const String token = "token";
  static const String branch = "branch";
  static const String cartList = "cart_list";
  static const String topic = 'notify';
  static const String userAddress = 'user_address';
  static const String searchAddress = 'search_address';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String userLogData = 'user_log_data';
  static const String placeOrderData = 'place_order_data';
}