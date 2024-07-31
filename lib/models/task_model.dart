import 'package:hive/hive.dart';
part 'task_model.g.dart';
@HiveType(typeId: 0)
class TaskModel extends HiveObject{
  TaskModel({required this.priority, required this.title, required this.category, required this.description, required this.date,required this.time});

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String category;

  @HiveField(3)
  String priority;

  @HiveField(4)
  String date;

  @HiveField(5)
  String time;



}