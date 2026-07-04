import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/auth_messages.dart';
import '../../../core/errors/firebase_error_handler.dart';
import '../../../core/utils/network_info.dart';
import '../data/auth_service.dart';

const _offlineMessage =
    'No internet connection. Please check your network and try again.';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final facebookAuthProvider = Provider<FacebookAuth>((ref) {
  return FacebookAuth.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    facebookAuth: ref.watch(facebookAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.loadingMessage,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String? loadingMessage;
  final String? errorMessage;
  final String? successMessage;

  AuthState copyWith({
    bool? isLoading,
    String? loadingMessage,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authService, this._networkInfo)
    : super(const AuthState());

  final AuthService _authService;
  final NetworkInfo _networkInfo;

  String? _verificationId;
  int? _resendToken;

  Future<bool> _isOffline() async => !(await _networkInfo.isConnected);

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: AuthMessages.signingInWithGoogle,
      errorMessage: null,
    );
    if (await _isOffline()) {
      state = state.copyWith(isLoading: false, errorMessage: _offlineMessage);
      return false;
    }
    try {
      await _authService.signInWithGoogle();
      state = state.copyWith(
        isLoading: false,
        successMessage: AuthMessages.loginSuccessful,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _errorText(e));
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: AuthMessages.signingInWithFacebook,
      errorMessage: null,
    );
    if (await _isOffline()) {
      state = state.copyWith(isLoading: false, errorMessage: _offlineMessage);
      return false;
    }
    try {
      await _authService.signInWithFacebook();
      state = state.copyWith(
        isLoading: false,
        successMessage: AuthMessages.loginSuccessful,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _errorText(e));
      return false;
    }
  }

  bool _autoVerified = false;

  Future<bool> sendOtp(String phoneNumber, {bool isResend = false}) async {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: AuthMessages.sendingOtp,
      errorMessage: null,
    );
    _autoVerified = false;

    if (await _isOffline()) {
      state = state.copyWith(isLoading: false, errorMessage: _offlineMessage);
      return false;
    }

    final completer = Completer<bool>();

    try {
      await _authService.sendOtp(
        phoneNumber: phoneNumber,
        forceResendingToken: isResend ? _resendToken : null,
        onAutoVerified: (credential) async {
          try {
            await _authService.signInWithPhoneCredential(credential);
            _autoVerified = true;
            state = state.copyWith(
              isLoading: false,
              successMessage: AuthMessages.phoneVerified,
            );
          } catch (e) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: _errorText(e),
            );
          }
          if (!completer.isCompleted) completer.complete(true);
        },
        onFailed: (message) {
          state = state.copyWith(isLoading: false, errorMessage: message);
          if (!completer.isCompleted) completer.complete(false);
        },
        onCodeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          state = state.copyWith(isLoading: false);
          if (!completer.isCompleted) completer.complete(true);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _errorText(e));
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  bool get isAutoVerified => _autoVerified;

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please request a new OTP.',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      loadingMessage: AuthMessages.verifyingOtp,
      errorMessage: null,
    );
    if (await _isOffline()) {
      state = state.copyWith(isLoading: false, errorMessage: _offlineMessage);
      return false;
    }
    try {
      await _authService.verifyOtp(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: AuthMessages.phoneVerified,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _errorText(e));
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: AuthMessages.loggingOut,
      errorMessage: null,
    );
    try {
      await _authService.signOut();
      state = state.copyWith(
        isLoading: false,
        successMessage: AuthMessages.loggedOut,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _errorText(e));
    }
  }

  String _errorText(Object e) {
    return FirebaseErrorHandler.handle(e, context: 'AuthController').message;
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.watch(authServiceProvider),
      ref.watch(networkInfoProvider),
    );
  },
);
