import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
