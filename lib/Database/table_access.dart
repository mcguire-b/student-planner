//import 'db_tables.dart';
import 'database.dart';

class TaskTableDA {
  final AppDatabase db;

  TaskTableDA(this.db);

  //method to add task to TaskTable Database
  Future<int> insertTask(TaskTableCompanion task) {
    return db.into(db.taskTable).insert(task);
  }

  Future<List<TaskTableData>> getAllTasks() {
    return db.select(db.taskTable).get();
  }
}