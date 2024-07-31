import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/boxes/box.dart';
import 'package:todo_app/models/task_model.dart';

class CompletedTaskWidget extends StatelessWidget {
  CompletedTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return ValueListenableBuilder<Box<TaskModel>>(
      valueListenable: Boxes.getData().listenable(),
      builder: (context, box, _) {
        var data=box.values.toList().cast<TaskModel>();
        return Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: ListTile(

                        title: Text(data[index].title, style: GoogleFonts.outfit()),
                        subtitle: Text(data[index].description, style: GoogleFonts.outfit()),
                        trailing: Text(data[index].category.toUpperCase(), style: GoogleFonts.outfit(fontSize: 15)),
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
