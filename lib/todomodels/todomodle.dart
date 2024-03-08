import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'todomodle.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  Todo({required this.title, required this.description});
}