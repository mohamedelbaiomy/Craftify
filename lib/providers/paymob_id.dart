class ApiConstant {
  // https://accept.paymob.com/api/auth/tokens
  static const String baseUrl = 'https://accept.paymob.com/api';
  static const String getAuthToken = '/auth/tokens';
  static const String paymentApiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TnpreE56Y3lMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuZFRjZ2Q0cENPNHNMV1Zhcm5GRGdKYUNkTUlmQVhvZW1zNFNsTDBpSjlFQ2hFdllqcFIwWTI3YU1aRTdZSnY2UG1PNV81QTBCR3ZQRE1DLXhuZ3Z1UXc=';
  static const String getOrderId = '/ecommerce/orders';
  static String paymentFirstToken = '';
  static String paymentOrderId = '';
}
