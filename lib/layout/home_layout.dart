// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, body_might_complete_normally_nullable, prefer_interpolation_to_compose_strings, prefer_is_empty, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/shared/components/componets.dart';
import 'package:fluttertest/shared/cubit/states.dart';
import 'package:fluttertest/shared/styles/colors.dart';
import 'package:intl/intl.dart';

import '../modules/notes/addnotes.dart';
import '../shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  static const String routeName = '/home';

  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is InsertDatabaseStates) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          body: ConditionalBuilder(
            condition: true,
            builder: (context) => cubit.screens[cubit.currant],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.currant == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNote()));
              } else {
                if (cubit.isBottomShow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertDataBase(
                      title: titleController.text,
                      body: bodyController.text,
                      time: timeController.text,
                      date: dateController.text,
                      status: "new",
                    )
                        .then((value) {
                      cubit.changeButtonSheet(
                        isShow: false,
                        icon: Icons.edit,
                      );
                      cubit.showNotification(
                        id: value.hashCode,
                        title: titleController.text,
                        body: bodyController.text,
                        seconds: DateFormat('hh:mm a')
                            .parse(timeController.text)
                            .minute,
                      );
                      print(DateFormat('hh:mm a')
                          .parse(timeController.text)
                          .minute);
                    }).catchError((onError) {
                      print(onError.toString() + "لم يتم الاغلاق ");
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 20,
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  onTap: () {},
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "title is not bo empty";
                                    }
                                  },
                                  label: "Task Title",
                                  prefix: Icons.title,
                                ),
                                SizedBox(height: 20),
                                defaultFormField(
                                  onTap: () {},
                                  controller: bodyController,
                                  type: TextInputType.text,
                                  validate: (String? value) {},
                                  label: "Task Details",
                                  prefix: Icons.note,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();

                                          print(timeController);
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.access_time,
                                              color: defaultColor),
                                          SizedBox(width: 12),
                                          Text(
                                            'Time',
                                            style:
                                                TextStyle(color: defaultColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 25.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse("2050-01-01"),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value!)
                                                  .toString();
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.date_range_outlined,
                                              color: defaultColor),
                                          SizedBox(width: 12),
                                          Text(
                                            'Date',
                                            style:
                                                TextStyle(color: defaultColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeButtonSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeButtonSheet(isShow: true, icon: Icons.add);
                }
              }
            },
            child: cubit.currant != 0
                ? Icon(cubit.fabIcon)
                : Icon(Icons.edit_note, size: 35),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.white, size: 30)),
            child: CurvedNavigationBar(
              onTap: (index) {
                cubit.changeIndex(index);
              },
              index: cubit.currant,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: defaultColor,
              color: Colors.teal,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              height: 50,
              items: [
                Icon(Icons.sticky_note_2_sharp),
                Icon(Icons.list, size: 25),
                Icon(Icons.done, size: 25),
                Icon(Icons.archive, size: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
