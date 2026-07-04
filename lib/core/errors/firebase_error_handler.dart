import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'app_exception.dart';
import 'app_logger.dart';

class FirebaseErrorHandler {
  FirebaseErrorHandler._();

  static const String _genericMessage =
      'Something went wrong. Please try again later.';

  static const String _networkMessage =
      'No internet connection. Please check your network and try again.';

  static AppException handle(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    final mapped = _map(error);
    AppLogger.logError(
      error,
      stackTrace: stackTrace,
      code: mapped.code,
      context: context,
    );
    return mapped;
  }

  static AppException _map(Object error) {
    if (error is AppException) return error;

    if (error is FirebaseAuthException) {
      return AppException(
        _authMessage(error.code),
        code: error.code,
        cause: error,
      );
    }
    if (error is FirebaseException) {
      return AppException(
        _firebaseMessage(error),
        code: error.code,
        cause: error,
      );
    }
    if (error is PlatformException) {
      return AppException(
        _platformMessage(error.code),
        code: error.code,
        cause: error,
      );
    }
    if (error is SocketException ||
        error is TimeoutException ||
        error is HandshakeException) {
      return AppException(_networkMessage, cause: error);
    }

    final message = error.toString();
    if (message.contains('BILLING_NOT_ENABLED')) {
      return AppException(
        'Phone verification is temporarily unavailable. Please contact support.',
        code: 'BILLING_NOT_ENABLED',
        cause: error,
      );
    }
    if (message.contains('17010') || message.contains('unusual activity')) {
      return AppException(
        'Too many verification attempts were made from this device.\n'
        'Please wait for some time before requesting another OTP.',
        code: '17010',
        cause: error,
      );
    }

    return AppException(_genericMessage, cause: error);
  }

  static String _authMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return _networkMessage;
      case 'operation-not-allowed':
        return 'Login is temporarily unavailable.';

      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should contain at least 6 characters.';

      case 'invalid-phone-number':
        return 'Enter a valid phone number.';
      case 'invalid-verification-code':
        return 'Incorrect OTP.';
      case 'invalid-verification-id':
        return 'Verification failed.';
      case 'session-expired':
        return 'OTP expired. Please request a new OTP.';
      case 'quota-exceeded':
        return 'SMS limit reached. Please try again later.';
      case 'captcha-check-failed':
        return 'Verification failed. Please try again.';
      case 'app-not-authorized':
        return 'App configuration error.';
      case 'missing-client-identifier':
        return 'Authentication configuration missing.';

      case 'requires-recent-login':
        return 'Please log in again to continue.';
      case 'credential-already-in-use':
        return 'This account is already linked to another user.';
      case 'user-mismatch':
        return 'These credentials do not match the signed-in user.';
      case 'user-token-expired':
        return 'Your session has expired. Please log in again.';

      default:
        return _genericMessage;
    }
  }

  static String _firebaseMessage(FirebaseException error) {
    if (error.plugin == 'cloud_firestore') {
      switch (error.code) {
        case 'permission-denied':
          return "You don't have permission to access this information.";
        case 'unavailable':
          return 'Server temporarily unavailable.';
        case 'deadline-exceeded':
          return 'Request timed out.';
        case 'not-found':
          return 'Requested information not found.';
        case 'already-exists':
          return 'Data already exists.';
        case 'resource-exhausted':
          return 'Service temporarily busy.';
        default:
          return _genericMessage;
      }
    }

    if (error.plugin == 'firebase_storage') {
      switch (error.code) {
        case 'object-not-found':
          return 'File not found.';
        case 'unauthorized':
          return 'Permission denied.';
        case 'retry-limit-exceeded':
          return 'Upload failed. Please try again.';
        case 'cancelled':
          return 'Upload cancelled.';
        default:
          return _genericMessage;
      }
    }

    return _genericMessage;
  }

  static String _platformMessage(String code) {
    switch (code) {
      case 'sign_in_canceled':
        return 'Google sign in cancelled.';
      case 'network_error':
        return 'Internet connection unavailable.';
      case 'developer_error':
        return 'Google Sign In configuration error.';
      case 'sign_in_failed':
        return 'Google Sign In failed.';

      case 'login_cancelled':
        return 'Facebook login cancelled.';
      case 'invalid_credentials':
        return 'Facebook authentication failed.';
      case 'permission_denied':
        return 'Facebook permission denied.';

      default:
        return _genericMessage;
    }
  }
}
