class AppConstants {
  static const String appName = 'Queen Fruits';
  // static const String baseUrl = 'http://localhost:8000';
  static const String baseUrl = 'https://www.webadmin.mitrajamur.com';
  static const String policyPage = '/api/v1/pages';
  static const String tokenUri = '/api/customer/cm-firebase-token';
  static const String subscribeToTopic = '/api/v1/fcm-subscribe-to-topic';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String categoryUri = '/api/v1/categories';
  static const String getDeliveryInfo = '/api/v1/config/delivery-fee';
  static const String configUri = '/api/v1/config';
  static const String searchSuggestion = '/api/v1/products/search-suggestion';
  static const String wishListGetUri = '/api/v1/customer/wish-list';
  static const String latestProductUri = '/api/v1/products/latest';
  static const String popularProductUri = '/api/v1/products/popular';
  static const String importProductUri = '/api/v1/products/set-menu';
  static const String recommendedProductUri = '/api/v1/products/recommended';
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String bannerUri = '/api/v1/banners';
  static const String searchRecommended = '/api/v1/products/search-recommended';
  static const String frequentlyBought = '/api/v1/products/frequently-bought';

  // Shared key
  static const String token = "token";
  static const String branch = "branch";
  static const String cartList = "cart_list";
  static const String topic = 'notify';
  static const String userAddress = 'user_address';
  static const String searchAddress = 'search_address';
  static const String onBoardingSkip = 'on_boarding_skip';
}