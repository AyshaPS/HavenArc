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
        return macos;
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
    apiKey: 'AIzaSyDcmIPafizu26DLL40pozvPLDPfmEMMq1g',
    appId: '1:869108209755:web:2290a5aa9047afc1e7877e',
    messagingSenderId: '869108209755',
    projectId: 'havenarc-40873',
    authDomain: 'havenarc-40873.firebaseapp.com',
    storageBucket: 'havenarc-40873.firebasestorage.app',
    measurementId: 'G-DQDK3TYCKE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCe_De-vHATT6SqefErFd0jb30cAj2HyHc',
    appId: '1:869108209755:android:20a156cc55faefd5e7877e',
    messagingSenderId: '869108209755',
    projectId: 'havenarc-40873',
    storageBucket: 'havenarc-40873.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfeSuNYxF2syRVyBybdqSVeSr8-R2Sg_Y',
    appId: '1:869108209755:ios:d3d17ed50016e5ece7877e',
    messagingSenderId: '869108209755',
    projectId: 'havenarc-40873',
    storageBucket: 'havenarc-40873.firebasestorage.app',
    androidClientId: '869108209755-868jpcrphom57bnq9vn2njag9g8jdtuq.apps.googleusercontent.com',
    iosClientId: '869108209755-ck89as4ni1fib9v89gdh3fen71d2t4c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.havenarcApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfeSuNYxF2syRVyBybdqSVeSr8-R2Sg_Y',
    appId: '1:869108209755:ios:d3d17ed50016e5ece7877e',
    messagingSenderId: '869108209755',
    projectId: 'havenarc-40873',
    storageBucket: 'havenarc-40873.firebasestorage.app',
    androidClientId: '869108209755-868jpcrphom57bnq9vn2njag9g8jdtuq.apps.googleusercontent.com',
    iosClientId: '869108209755-ck89as4ni1fib9v89gdh3fen71d2t4c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.havenarcApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcmIPafizu26DLL40pozvPLDPfmEMMq1g',
    appId: '1:869108209755:web:636ad0ed3288f1e3e7877e',
    messagingSenderId: '869108209755',
    projectId: 'havenarc-40873',
    authDomain: 'havenarc-40873.firebaseapp.com',
    storageBucket: 'havenarc-40873.firebasestorage.app',
    measurementId: 'G-X1HR024ZWE',
  );

}