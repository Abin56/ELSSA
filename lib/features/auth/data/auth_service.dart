import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/firebase_error_handler.dart';

class AuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _facebookAuth = facebookAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AppException(
        'Google sign in cancelled.',
        code: 'sign_in_canceled',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await saveUserData(userCredential.user!, provider: 'google');
    return userCredential;
  }

  Future<UserCredential> signInWithFacebook() async {
    final result = await _facebookAuth.login();
    if (result.status == LoginStatus.cancelled) {
      throw const AppException(
        'Facebook login cancelled.',
        code: 'login_cancelled',
      );
    }
    if (result.status != LoginStatus.success) {
      throw const AppException(
        'Facebook authentication failed.',
        code: 'invalid_credentials',
      );
    }

    final accessToken = result.accessToken;
    if (accessToken == null) {
      throw const AppException(
        'Facebook authentication failed.',
        code: 'invalid_credentials',
      );
    }

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await saveUserData(userCredential.user!, provider: 'facebook');
    return userCredential;
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
    required void Function(String message) onFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    int? forceResendingToken,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: onAutoVerified,
      verificationFailed: (e) {
        onFailed(FirebaseErrorHandler.handle(e, context: 'sendOtp').message);
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return signInWithPhoneCredential(credential);
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await saveUserData(userCredential.user!, provider: 'phone');
    return userCredential;
  }

  Future<void> saveUserData(User user, {required String provider}) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'phone': user.phoneNumber,
        'photoUrl': user.photoURL,
        'provider': provider,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({'lastLogin': FieldValue.serverTimestamp()});
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }
}
