// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/layout/home_layout.dart';

import '../../shared/components/componets.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class EditNote extends StatelessWidget {
  final int id;
  final String title;
  final String body;

  const EditNote({
    Key? key,
    required this.title,
    required this.body,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var myController = TextEditingController();
    var bodyController = TextEditingController();
    myController.text = title;
    bodyController.text = body;
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
                cubit.updateEditNote(
                  id: id,
                  title: myController.text,
                  body: bodyController.text,
                );
                navigateAndFinish(context, HomeLayout());
              },
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  myPopupMenu(context, id),
                ],
              )
            ],
            title: TextField(
              controller: myController,
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.grey[350],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none),
              style: TextStyle(fontSize: 20),
              minLines: 1,
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: TextField(
              controller: bodyController,
              maxLines: double.maxFinite.toInt(),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
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
