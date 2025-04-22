import 'package:drift/drift.dart';
import 'package:planner/Database/database.dart';

final db = AppDatabase();

class TaskTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventName => text()();
  TextColumn get eventCategory => text()(); 
  TextColumn get eventPriority => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get anticipatedTime => integer()(); //in minutes
}