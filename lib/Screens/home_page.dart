import 'dart:core';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Reusable%20components/completed_task.dart';
import 'package:todo_app/Reusable%20components/form_field.dart';
import 'package:todo_app/Reusable%20components/pending_task_widget.dart';
import 'package:todo_app/Reusable%20components/progress_indicator.dart';
import 'package:todo_app/Reusable%20components/route.dart';
import 'package:todo_app/boxes/box.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/main.dart';


const String channelId = 'task_reminder_channel';
const String channelName = 'Task Reminders';
const String channelDescription = 'Channel for task reminder notifications';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var location=tz.getLocation('Asia/Kolkata');


  double progressVal = 1;
  double maxVal = 1; // Initialize maxVal to 1 to avoid issues
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();


  RouteFunction homeScreenRoute = RouteFunction();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    updateTaskCount();
  }

  void updateTaskCount() {
    setState(() {
      final box = Boxes.getData();
      maxVal = box != null && box.isNotEmpty ? box.length.toDouble() : 1;
      progressVal =
          maxVal; // For displaying total task count in progress indicator
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> scheduleAlarm(DateTime scheduledDate) async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
        'todo_app',
        'todo_app',
        channelDescription: 'this is a todo app',
        icon: 'img'
    );
    var platformSpecifics = NotificationDetails(android: androidChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      'You have a task due',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Task"),
          actions: [
            TextButton(
                onPressed: () async {
                  final dateFormat = DateFormat('yyyy-MM-dd').format(
                      selectedDate);
                  final timeFormat = selectedTime.format(context);
                  final data = TaskModel(
                      priority: priorityController.text,
                      title: titleController.text,
                      category: categoryController.text,
                      description: descController.text,
                      date: dateFormat.toString(),
                      time: timeFormat.toString());

                  final box = Boxes.getData();
                  box.add(data);
                  data.save();

                  // Schedule the alarm
                  DateTime scheduledDate = DateFormat('yyyy-MM-dd').parse(
                      dateFormat);
                  scheduledDate = DateTime(
                    scheduledDate.year,
                    scheduledDate.month,
                    scheduledDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  Navigator.pop(context);
                  await scheduleAlarm(selectedDate);


                  titleController.clear();
                  descController.clear();
                  priorityController.clear();
                  categoryController.clear();

                  updateTaskCount();

                },
                child: const Text("Add")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"))
          ],
          content: SingleChildScrollView(
            child: Container(
              height: 330,
              child: Column(
                children: [
                  CustomTextField(
                      textHint: "Enter Title", textController: titleController),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                      textHint: "Enter Description",
                      textController: descController),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                      textHint: "Enter Priority",
                      textController: priorityController),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      textHint: "Enter Category",
                      textController: categoryController),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                (states) {
                              return Colors.black87;
                            },
                          )),
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text(
                            "Select Time",
                            style: GoogleFonts.outfit(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                  (states) {
                                return const Color.fromRGBO(78, 52, 241, 50);
                              },
                            )),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text("Select Date",
                            style: GoogleFonts.outfit(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Home Page",
                  style: GoogleFonts.josefinSans(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  updateTaskCount();
                },
                child: const Icon(Icons.refresh, color: Colors.black87),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 243, 243),
        body: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Container(
                      height: 180,
                      width: 180,
                      child: CustomProgressIndicator(
                        progressVal: progressVal,
                        maxVal: maxVal,
                        completionColor: Colors.cyan,
                        incompleteColor: Colors.cyan.shade100,
                        progressIndicatorText: maxVal != 0
                            ? '$maxVal Tasks Created'
                            : 'No Task Created',
                      ),
                    ),
                  ),
                ),
                const TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: "Pending"),
                    Tab(text: "Completed"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [PendingTaskWidget(), CompletedTaskWidget()],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              right: screenHeight * 0.02,
              child: FloatingActionButton(
                onPressed: () {
                  _showDialog();
                },
                backgroundColor: Colors.cyan.shade200,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
