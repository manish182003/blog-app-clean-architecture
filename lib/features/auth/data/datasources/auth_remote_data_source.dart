import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currenUserSession;
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currenUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      if (res.user == null) {
        throw ServerException('User is null');
      }

      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: currenUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        'name': name,
      });

      if (res.user == null) {
        throw ServerException('User is null');
      }

      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: currenUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currenUserSession != null) {
        final userdata = await supabaseClient.from('profiles').select().eq(
              'id',
              currenUserSession!.user.id,
            );

        return UserModel.fromJson(userdata.first).copyWith(
          email: currenUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
