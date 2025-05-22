class ApiResponseModel<T> {
  final T? response;
  final dynamic error;
  final bool isSuccess;

  ApiResponseModel(this.response, this.error, this.isSuccess);

  ApiResponseModel.withError(dynamic errorValue) : response = null, error = errorValue, isSuccess = false;

  ApiResponseModel.withSuccess(T? responseValue) : response = responseValue, error = null, isSuccess = true;

  @override
  String toString() {
    return 'ApiResponseModel{response: ${response}, error: $error, isSuccess: $isSuccess}';
  }
}