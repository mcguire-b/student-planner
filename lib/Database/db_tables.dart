import 'package:drift/drift.dart';

class TaskTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventName => text()();
  TextColumn get eventCategory => text()(); // not sure if storing as int or string is better yet
  //IntColumn get eventCategory2 => integer()(); //0 == work, 1 == personal, 2 == school, 3 == other 
  //IntColumn get eventPriority => integer()(); //0 == low, 1 == medium, 2 == high 
  TextColumn get eventPriority => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get anticipatedTime => integer()(); //in minutes

}