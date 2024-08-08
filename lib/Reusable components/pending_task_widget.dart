import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/boxes/box.dart';
import 'package:todo_app/models/task_model.dart';

import 'form_field.dart';

class PendingTaskWidget extends StatefulWidget {
  PendingTaskWidget({super.key});

  @override
  State<PendingTaskWidget> createState() => _PendingTaskWidgetState();
}

class _PendingTaskWidgetState extends State<PendingTaskWidget> {
  TextEditingController titleController=TextEditingController();
  TextEditingController priorityController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController descController=TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
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

  //Alarm Call back function

  Future<void> _editDialog(TaskModel taskModel,String title, String desc, String priority, String category, String date, String time) async {
    titleController.text=title;
    descController.text=desc;
    priorityController.text=priority;
    categoryController.text=category;
    date=selectedDate.toString();
    time=selectedTime.toString();


    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Task"),
          actions: [
            TextButton(
                onPressed: () {
                  final dateFormat = DateFormat('yyyy-MM-dd').format(selectedDate);
                  final timeFormat = selectedTime.format(context);
                  taskModel.title=titleController.text;
                  taskModel.category=categoryController.text;
                  taskModel.priority=priorityController.text;
                  taskModel.description=descController.text;
                  taskModel.time=timeFormat;
                  taskModel.date=dateFormat;
                  titleController.clear();
                  descController.clear();
                  priorityController.clear();
                  categoryController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Edit")),
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
                          WidgetStateProperty.resolveWith<Color?>(
                                (states) {
                              return Colors.black87;
                            },
                          )),
                          onPressed: () {
                            _selectTime(context);
                          },
                          child:  Text("Select Time", style: GoogleFonts.outfit(color: Colors.white) ,),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),

                      ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                        WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                            return const Color.fromRGBO(78, 52, 241, 50);
                          },
                        )),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child:  Text("Select Date",style: GoogleFonts.outfit(color: Colors.white)),
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


  Future<void> _showTaskDialog(TaskModel task) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title, style: GoogleFonts.outfit()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(task.description, style: GoogleFonts.outfit()),
              SizedBox(height: 8),

              Text('Category:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(task.category, style: GoogleFonts.outfit()),
              SizedBox(height: 8),
              Text('Priority:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(task.priority, style: GoogleFonts.outfit()),
              SizedBox(height: 8),
              Text('Due Date:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('${task.date} at ${task.time}', style: GoogleFonts.outfit()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: GoogleFonts.outfit()),
            ),TextButton(
              onPressed: () {
                task.delete();
                Navigator.of(context).pop();

              },
              child: Text('Delete Task', style: GoogleFonts.outfit()),
            ),
            TextButton(
              onPressed: () async{
                await _editDialog(task, task.title, task.description, task.priority, task.category, task.date, task.time);
                Navigator.of(context).pop();

              },
              child: Text('Edit', style: GoogleFonts.outfit()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return ValueListenableBuilder<Box<TaskModel>>(
      valueListenable: Boxes.getData().listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<TaskModel>();
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showTaskDialog(data[index]);
                      },
                      child: ListTile(
                        title: Text(data[index].title,
                            style: GoogleFonts.outfit()),
                        subtitle: Text(data[index].description,
                            style: GoogleFonts.outfit()),
                        trailing: Text(
                          'Due \n${data[index].date}  \n ${data[index].time}',
                          style: GoogleFonts.outfit(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1);
                  },
                  itemCount: data.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
