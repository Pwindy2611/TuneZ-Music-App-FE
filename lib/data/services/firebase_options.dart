import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'default_api_key',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'default_auth_domain',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_project_id',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_storage_bucket',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'default_messaging_sender_id',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'default_app_id',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? 'default_measurement_id',
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'default_api_key',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'default_auth_domain',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_project_id',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_storage_bucket',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'default_messaging_sender_id',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'default_app_id',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? 'default_measurement_id',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return FirebaseOptions(
       apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'default_api_key',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'default_auth_domain',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_project_id',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_storage_bucket',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'default_messaging_sender_id',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'default_app_id',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? 'default_measurement_id',
      );
    }
    throw UnsupportedError('Platform not supported');
  }
}
