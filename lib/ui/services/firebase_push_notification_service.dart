import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebasePushNotificationService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebasePushNotificationService._(); //named constructor private kore dichi

  static final FirebasePushNotificationService instance = FirebasePushNotificationService
      ._();


  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {

    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

 //initialization local notification
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('flutter');
    final DarwinInitializationSettings iosIntializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id,String ? title,String?body, String ? payload) async{}
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosIntializationSettings
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{});



    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);

      //trigger the local notification
      _showNotification(title: 'Hello local notification',body: 'Its working');

    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
    });

    // Handle notifications when the app is completely terminated

    FirebaseMessaging.onBackgroundMessage(doNothing);
    String ? token = await getToken();
    print(token);
  }

//get the token
Future<String?> getToken() async{
   String ? token = await _firebaseMessaging.getToken();//firebase unique token genarate kore diye dibe
  return token;
}

//for refresh token
Future<void> onTokenRefresh() async{
    _firebaseMessaging.onTokenRefresh.listen((token) {
      //call an api
      //send me token
    });
}

  Future<void> _showNotification({int id = 0,String ? title,String ? body,String ? payload}) async{
    return _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails());

  }
  NotificationDetails notificationDetails(){
    return const  NotificationDetails(
        android: AndroidNotificationDetails('channelId','channelName',importance: Importance.max),
        iOS: DarwinNotificationDetails()
    );
  }






}

  Future<void> doNothing(RemoteMessage remoteMessage) async{

  }

