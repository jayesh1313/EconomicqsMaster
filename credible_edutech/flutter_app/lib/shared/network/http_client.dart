import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JwtInterceptor extends Interceptor {
  final SupabaseClient supabaseClient;

  JwtInterceptor(this.supabaseClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
      options.headers['Referer'] = 'app://economicqsmaster.com';
    } catch (e) {
      print('Error injecting JWT: $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Dio error: ${err.message}');
    handler.next(err);
  }
}

class HttpClient {
  static late Dio _dio;
  
  static void initialize(SupabaseClient supabaseClient) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );
    
    _dio.interceptors.add(JwtInterceptor(supabaseClient));
  }
  
  static Dio getInstance() => _dio;
  
  static Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      print('GET Error: ${e.message}');
      rethrow;
    }
  }
  
  static Future<dynamic> post(String url, {required dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on DioException catch (e) {
      print('POST Error: ${e.message}');
      rethrow;
    }
  }
  
  static Future<dynamic> patch(String url, {required dynamic data}) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response.data;
    } on DioException catch (e) {
      print('PATCH Error: ${e.message}');
      rethrow;
    }
  }
}
