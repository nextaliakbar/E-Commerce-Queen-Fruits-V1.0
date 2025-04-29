import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPaperLine = 200;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    // TODO: implement onResponse

    debugPrint(
      "<-- ${response.statusCode} ${response.requestOptions} ${response.requestOptions.path}");

    String responseAsString = response.data.toString();

    if(responseAsString.length > maxCharactersPaperLine) {
      int iterations = (responseAsString.length / maxCharactersPaperLine).floor();
      for(int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPaperLine + maxCharactersPaperLine;

        if(endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }

        debugPrint(responseAsString.substring(i * maxCharactersPaperLine, endingIndex));
      }
    } else {
      debugPrint(response.data);
    }

    debugPrint("<-- END HTTP");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    return super.onError(err, handler);
  }
}