import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live_score_application/app.dart';
import 'package:live_score_application/ui/services/firebase_push_notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
 await FirebasePushNotificationService.instance.initialize();
  runApp(const MyApp());
}

