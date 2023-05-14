// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/layout/home_layout.dart';
import 'package:fluttertest/shared/components/componets.dart';
import 'package:intl/intl.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var bodyController = TextEditingController();
    final date = DateTime.now();
    final formattedDate = MyDateFormatter.format(date);

    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 1,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (bodyController.text.isEmpty) {
                    Navigator.pushReplacementNamed(
                        context, HomeLayout.routeName);
                  } else {
                    cubit
                        .insertDataBase(
                      title: titleController.text,
                      body: bodyController.text,
                      time: TimeOfDay.now().format(context),
                      date: formattedDate,
                      status: "note",
                    )
                        .then((value) {
                      navigateAndFinish(context, HomeLayout());
                    });
                  }
                }),
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              )
            ],
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none),
              controller: titleController,
              minLines: 1,
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: TextField(
              onTap: () {},
              controller: bodyController,
              maxLines: double.maxFinite.toInt(),
              textInputAction: TextInputAction.none,
              decoration: InputDecoration(border: InputBorder.none),
              autofocus: true,
              autocorrect: false,
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}

class MyDateFormatter {
  static String format(DateTime date) {
    return DateFormat.yMd().format(date);
  }
}
