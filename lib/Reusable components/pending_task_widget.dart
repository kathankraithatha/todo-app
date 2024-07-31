import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/boxes/box.dart';
import 'package:todo_app/models/task_model.dart';

class PendingTaskWidget extends StatefulWidget {
  PendingTaskWidget({super.key});

  @override
  State<PendingTaskWidget> createState() => _PendingTaskWidgetState();
}

class _PendingTaskWidgetState extends State<PendingTaskWidget> {

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
