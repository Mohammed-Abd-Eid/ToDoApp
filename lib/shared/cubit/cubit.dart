// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertest/modules/notes/notes.dart';
import 'package:fluttertest/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../layout/home_layout.dart';
import '../../modules/tasks/archive.dart';
import '../../modules/tasks/done.dart';
import '../../modules/tasks/tasks.dart';
import '../network/local/notification.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialStates());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);
  int currant = 0;
  Database? database;
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  List<Map> notes = [];
  bool isBottomShow = false;
  IconData fabIcon = Icons.edit;
  Map<dynamic, bool> selectedItems = {};
  List screens = [
    NotesApp(),
    NewTasks(),
    Done(),
    Archive(),
  ];

  void changeIndex(int index) {
    currant = index;
    emit(AppChangeBottomNavStates());
  }

  Future<void> changeBack(context) async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => HomeLayout(),
        ));
    emit(ChangeBackStates());
  }

  void createDataBase() {
    openDatabase("ToSe.db", version: 1,
        onCreate: (Database database, int version) async {
      await database
          .execute(
              'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, body TEXT, data TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("create true");
      }).catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (database) {
      getDataBase(database);
    }).then((value) {
      database = value;
      emit(CreateDatabaseStates());
    });
  }

  Future insertDataBase({
    required String title,
    required String body,
    required String time,
    required String date,
    String? status,
  }) async {
    // Insert some records in a transaction
    return await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Task(title, body, data, time, status) VALUES("$title", "$body", "$date", "$time","$status")')
          .then((value) {
        emit(InsertDatabaseStates());
        getDataBase(database);
      }).catchError((onError) {
        onError.toString();
        emit(InsertDatabaseErrorStates());
      });
    });
  }

  void getDataBase(database) {
    tasks = [];
    doneTasks = [];
    archiveTasks = [];
    notes = [];
    emit(GetDatabaseLoadingStates());
    database.rawQuery("SELECT * FROM Task").then((value) {
      value.forEach((element) {
        if (element["status"] == "new") {
          tasks.add(element);
        } else if (element["status"] == "done") {
          doneTasks.add(element);
        } else if (element["status"] == "note") {
          notes.add(element);
        } else if (element["status"] == "archive") {
          archiveTasks.add(element);
        }
      });

      emit(GetDatabaseStates());
    });
  }

  void changeButtonSheet({required bool isShow, required IconData icon}) {
    isBottomShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }

  void updateDataBase({
    required String status,
    required int id,
  }) async {
    return await database!.rawUpdate('UPDATE Task SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataBase(database);
      emit(UpDataDatabaseStates());
    });
  }

  void deleteDataBase({required int id}) {
    // Delete a record
    database!.rawDelete('DELETE FROM Task WHERE id = ?', [id]).then((value) {
      getDataBase(database);
      emit(DeleteDatabaseStates());
    });
  }

  void updateEditNote({
    required int id,
    required String title,
    required String body,
  }) async {
    return await database!.rawUpdate(
        'UPDATE Task SET title = ?, body = ? WHERE id = ?',
        ['$title', '$body', id]).then((value) {
      getDataBase(database);

      emit(UpDataEditNoteStates());
    });
  }

  void initializeTimeZones() {
    tz.initializeTimeZones();
    emit(InitializeTimeZonesStates());
  }

  void showNotification(
      {required int id,
      required String title,
      required String body,
      required int seconds}) {
    NotificationService.flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(minutes: seconds)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/icon_app',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    )
        .then((value) {
      emit(NotificationStates());
    });
  }

  String _selectedItem = 'Item 1';

  void onChang(value) {
    _selectedItem = value as String;
  }

  void onBock() {}
}
