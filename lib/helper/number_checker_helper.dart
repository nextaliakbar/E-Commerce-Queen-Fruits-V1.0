class NumberCheckHelper {
  static bool isNumber(String number) {
    return number.split('').every((digit) => '0123456789'.contains(digit));
  }

  static String? getPhoneNumber(String phoneNumberWithCountryCode, String countryCode) {
    String phoneNumber = phoneNumberWithCountryCode.split(countryCode).last;
    return phoneNumber;
  }
}