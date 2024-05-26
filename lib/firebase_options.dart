// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAJHTI1B9D1-tMhx9luMupHj1cRWgIhscs',
    appId: '1:525325933032:web:3cb73433fe0d0eb648ec5d',
    messagingSenderId: '525325933032',
    projectId: 'organix-aee13',
    authDomain: 'organix-aee13.firebaseapp.com',
    storageBucket: 'organix-aee13.appspot.com',
    measurementId: 'G-MS5H20S9YN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9XyK9yqT_GIhUQB1ByeorOtZNHXiknVo',
    appId: '1:525325933032:android:686f601cf09ae39248ec5d',
    messagingSenderId: '525325933032',
    projectId: 'organix-aee13',
    storageBucket: 'organix-aee13.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGwtpElw6eyQQdrohuGcR7IMSl2buBHSo',
    appId: '1:525325933032:ios:91b527570509915d48ec5d',
    messagingSenderId: '525325933032',
    projectId: 'organix-aee13',
    storageBucket: 'organix-aee13.appspot.com',
    iosBundleId: 'com.example.organixx',
  );
}
