// ignore_for_file: always_use_package_imports, invalid_return_type_for_catch_error

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/global_config.dart';

class HttpHelper {
  String noInternetMessage = 'لا يوجد إتصال بالإنترنت';
  String connectionTimeOutMessage = 'خطأ فى الإتصال بالخادم';
  String sendingTimeOutMessage = 'خطأ فى الإتصال بالخادم';
  String notSuccessResponse = 'خطأ فى الإتصال بالخادم';
  String recivingTimeOutMessage = 'خطأ فى الإتصال بالخادم';
  String authorizationMessage = 'غير مسموح الإتصال بالخادم';

  Dio _getDio() {
    final Dio dio = Dio()..options.baseUrl = apiUrl;
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.sendTimeout = 60000;

    return dio;
  }

  Future<Map<String, String>> getHeaders() async {
    return {
      "content-type": "application/json",
      "accept": "application/json",
      "platform": Platform.isAndroid ? "android" : "ios",
      "app_version": (await PackageInfo.fromPlatform()).version,
    };
  }

  Future<Response> postJsonData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final response = await _getDio()
        .post(url, data: data, options: await _getRequestOptions(token))
        .catchError((e) => mapErrorResponse(e));

    return response;
  }

  Future<Response> putJsonData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final response = await _getDio()
        .put(url, data: data, options: await _getRequestOptions(token))
        .catchError((e) => mapErrorResponse(e));
    return response;
  }

  Future<Response> deleteData({
    required String url,
    String? token,
  }) async {
    final response = await _getDio()
        .delete(url, options: await _getRequestOptions(token))
        .catchError((e) => mapErrorResponse(e));
    return response;
  }

  Future<Response> getJsonData({
    required String url,
    String? token,
    Map<String, dynamic>? params,
  }) async {
    final response = await _getDio()
        .get(
          url,
          queryParameters: params,
          options: await _getRequestOptions(token),
        )
        .catchError((e) => mapErrorResponse(e));
    return response;
  }

  Future<Response> getFile({required String url}) async {
    Response response =
        await Dio().get(url).catchError((e) => mapErrorResponse(e));
    return response;
  }

  Future<Options> _getRequestOptions(token) async {
    Map<String, dynamic> headers = await getHeaders();

    if (token != null) headers["authorization"] = token;
    final options = Options(
      headers: headers,
      validateStatus: (s) => true,
      receiveDataWhenStatusError: false,
    );
    return options;
  }

  void mapErrorResponse(dynamic e) {
    if (e is DioError) {
      final DioError error = e;
      if (error.error is SocketException) {
        throw HttpException(noInternetMessage);
      } else if (error.type == DioErrorType.connectTimeout) {
        throw HttpException(connectionTimeOutMessage);
      } else if (error.type == DioErrorType.receiveTimeout) {
        throw HttpException(recivingTimeOutMessage);
      } else if (error.type == DioErrorType.sendTimeout) {
        throw HttpException(sendingTimeOutMessage);
      } else if (error.type == DioErrorType.response) {
        throw HttpException(notSuccessResponse);
      } else if (error.type != DioErrorType.cancel) {
        throw HttpException(notSuccessResponse);
      }
    } else {
      throw HttpException(e.toString());
    }
  }
}
