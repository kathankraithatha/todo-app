import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/Screens/home_page.dart';
import 'package:todo_app/Screens/intro_page.dart';
import 'package:todo_app/models/task_model.dart';

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
