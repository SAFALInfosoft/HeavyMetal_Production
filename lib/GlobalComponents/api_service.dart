import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'ErrorDataModel.dart';

class NewApiService {
  final Dio _dio;
  final String _defaultBaseUrl;

  /// Public getter so other files can read the base URL (for logging)
  String get baseUrl => _defaultBaseUrl;

  NewApiService({String? defaultBaseUrl})
      : _defaultBaseUrl = defaultBaseUrl ?? '',
        _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    // Optional: log every request/response automatically
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  /// Core request method
  Future<dynamic> _request(
      String path, {
        String method = 'GET',
        String? baseUrl,
        Map<String, dynamic>? queryParameters,
        dynamic data,
        bool useHttp = false,
        Map<String, String>? headers,
      }) async {
    final urlToUse = (baseUrl ?? _defaultBaseUrl).isNotEmpty
        ? (baseUrl ?? _defaultBaseUrl) + path
        : path;

    if (useHttp) {
      try {
        final clientHeaders = {'Content-Type': 'application/json', ...?headers};
        http.Response response;

        switch (method) {
          case 'POST':
            response = await http.post(Uri.parse(urlToUse),
                headers: clientHeaders, body: jsonEncode(data));
            break;
          case 'PUT':
            response = await http.put(Uri.parse(urlToUse),
                headers: clientHeaders, body: jsonEncode(data));
            break;
          case 'PATCH':
            response = await http.patch(Uri.parse(urlToUse),
                headers: clientHeaders, body: jsonEncode(data));
            break;
          case 'DELETE':
            response = await http.delete(Uri.parse(urlToUse),
                headers: clientHeaders, body: jsonEncode(data));
            break;
          default:
            final uri =
            Uri.parse(urlToUse).replace(queryParameters: queryParameters);
            response = await http.get(uri, headers: clientHeaders);
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else {
          throw ErrorData(
            type: 'Error',
            message: 'HTTP ${response.statusCode}: ${response.body}',
            settings: Settings(success: '0'),
          );
        }
      } catch (e) {
        throw ErrorData(
          type: 'Error',
          message: e.toString(),
          settings: Settings(success: '0'),
        );
      }
    } else {
      try {
        final response = await _dio.request(
          urlToUse,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: method, headers: headers),
        );

        if (response.data is Map<String, dynamic>) {
          final resData = response.data as Map<String, dynamic>;
          if (resData.containsKey('type') &&
              resData['type']?.toString().toLowerCase() == 'error') {
            throw ErrorData.fromJson(resData);
          }
        }
        return response.data;
      } on DioError catch (e) {
        throw ErrorData(
          type: 'Error',
          message: e.response?.data?['message']?.toString() ??
              e.message.toString() ??
              'Unexpected network error',
          settings: Settings(success: '0'),
        );
      }
    }
  }

  // Public helpers
  Future<dynamic> get(String path,
      {String? baseUrl,
        Map<String, dynamic>? queryParameters,
        bool useHttp = false,
        Map<String, String>? headers}) =>
      _request(path,
          method: 'GET',
          baseUrl: baseUrl,
          queryParameters: queryParameters,
          useHttp: useHttp,
          headers: headers);

  Future<dynamic> post(String path,
      {String? baseUrl,
        dynamic data,
        bool useHttp = false,
        Map<String, String>? headers}) =>
      _request(path,
          method: 'POST',
          baseUrl: baseUrl,
          data: data,
          useHttp: useHttp,
          headers: headers);

  Future<dynamic> put(String path,
      {String? baseUrl,
        dynamic data,
        bool useHttp = false,
        Map<String, String>? headers}) =>
      _request(path,
          method: 'PUT',
          baseUrl: baseUrl,
          data: data,
          useHttp: useHttp,
          headers: headers);

  Future<dynamic> patch(String path,
      {String? baseUrl,
        dynamic data,
        bool useHttp = false,
        Map<String, String>? headers}) =>
      _request(path,
          method: 'PATCH',
          baseUrl: baseUrl,
          data: data,
          useHttp: useHttp,
          headers: headers);

  Future<dynamic> delete(String path,
      {String? baseUrl,
        dynamic data,
        bool useHttp = false,
        Map<String, String>? headers}) =>
      _request(path,
          method: 'DELETE',
          baseUrl: baseUrl,
          data: data,
          useHttp: useHttp,
          headers: headers);
}
