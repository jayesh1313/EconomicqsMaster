import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String deviceId;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [userId, email, deviceId];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient supabaseClient;
  String _deviceId = '';

  AuthBloc({required this.supabaseClient}) : super(const AuthInitial()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<String> _getDeviceId() async {
    if (_deviceId.isNotEmpty) return _deviceId;

    final deviceInfo = DeviceInfoPlugin();
    String id = '';

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        id = webInfo.userAgent ?? 'web_${DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        id = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      print('Error getting device ID: $e');
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    _deviceId = id;
    return _deviceId;
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = supabaseClient.auth.currentSession;
      final deviceId = await _getDeviceId();

      if (session != null) {
        // Verify device binding
        final userProfile = await supabaseClient
            .from('profiles')
            .select('device_id')
            .eq('id', session.user.id)
            .single();

        final storedDeviceId = userProfile['device_id'];
        if (storedDeviceId != deviceId) {
          await supabaseClient.auth.signOut();
          emit(const AuthUnauthenticated());
          return;
        }

        emit(AuthAuthenticated(
          userId: session.user.id,
          email: session.user.email ?? '',
          deviceId: deviceId,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication status: $e'));
    }
  }

  Future<void> _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final deviceId = await _getDeviceId();

      final response = await supabaseClient.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        // Update device_id in profiles table
        await supabaseClient.from('profiles').update({
          'device_id': deviceId,
        }).eq('id', response.user!.id);

        emit(AuthAuthenticated(
          userId: response.user!.id,
          email: response.user!.email ?? '',
          deviceId: deviceId,
        ));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> _onRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final deviceId = await _getDeviceId();

      final response = await supabaseClient.auth.signUp(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        // Create profile with device binding
        await supabaseClient.from('profiles').insert({
          'id': response.user!.id,
          'full_name': event.fullName,
          'device_id': deviceId,
          'tier': 'free',
        });

        emit(AuthAuthenticated(
          userId: response.user!.id,
          email: response.user!.email ?? '',
          deviceId: deviceId,
        ));
      }
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await supabaseClient.auth.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }
}
