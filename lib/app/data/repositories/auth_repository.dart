import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/auth_models/login_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_model.dart';

abstract class IAuthRepository {
  Future<LoginModel> login({required String email, required String password});

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  });

  Future<UserModel> getMe();

  Future<void> logout();
}

class AuthRepository implements IAuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

  @override
  Future<LoginModel> login({required String email, required String password}) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.login,
        data: {'email': email, 'password': password},
      ),
      (dynamic data) => LoginModel.fromJson(data),
      'Login',
    );
  }

  @override
  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phone_number': phoneNumber,
          'type': 'CLIENT',
        },
      ),
      (dynamic data) => data,
      'Register',
    );
  }

  @override
  Future<UserModel> getMe() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.me),
      (dynamic data) => UserModel.fromJson(data),
      'Get Me',
    );
  }

  @override
  Future<void> logout() {
    return _client.handleRequest(
      () => _client.dio.post(ApiEndpoint.logout),
      (_) {},
      'Logout',
    );
  }
}
