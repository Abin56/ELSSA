// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCEGKAHhqDX79XXwp8bSoP4AEvNzycSb_A',
    appId: '1:557989601849:web:5919ba4f795851ef4aa3e8',
    messagingSenderId: '557989601849',
    projectId: 'elssa-7625e',
    authDomain: 'elssa-7625e.firebaseapp.com',
    storageBucket: 'elssa-7625e.firebasestorage.app',
    measurementId: 'G-PNE90NN111',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDffVhwfcRzX53ju6chIBP2DxSqTVJv0CE',
    appId: '1:557989601849:android:6aa6f28b4f3efd2c4aa3e8',
    messagingSenderId: '557989601849',
    projectId: 'elssa-7625e',
    storageBucket: 'elssa-7625e.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEGKAHhqDX79XXwp8bSoP4AEvNzycSb_A',
    appId: '1:557989601849:web:d1656ca6a1019e624aa3e8',
    messagingSenderId: '557989601849',
    projectId: 'elssa-7625e',
    authDomain: 'elssa-7625e.firebaseapp.com',
    storageBucket: 'elssa-7625e.firebasestorage.app',
    measurementId: 'G-F6HDFQXJR2',
  );
}
