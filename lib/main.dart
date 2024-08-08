import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/Screens/home_page.dart';
import 'package:todo_app/Screens/intro_page.dart';
import 'package:todo_app/models/task_model.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> requestNotificationPermission() async {
  if (await Permission.notification.request().isGranted) {
    // Permission is granted
    print("Permission given");
  } else {
    print("Permission denied");
    // Permission is denied
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Hive
  var directory= await getApplicationCacheDirectory();
  Hive.init(directory.path);
  // Register adapter
  Hive.registerAdapter(TaskModelAdapter());

  // Open the box
  Hive.openBox<TaskModel>('task');
  await requestNotificationPermission();
  tz.initializeTimeZones();
  tz.getLocation('Asia/Kolkata');


  var initalizationSettingsAndroid=const AndroidInitializationSettings('img');
  var initalizationSetting=InitializationSettings(android: initalizationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initalizationSetting);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}
