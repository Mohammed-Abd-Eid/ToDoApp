// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertest/shared/cubit/cubit.dart';
import 'package:fluttertest/shared/styles/colors.dart';

import '../../modules/notes/editNotes.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: () => function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  int? maxLines,
}) =>
    TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      enabled: isClickable,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () => suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
//String title, String time, String data
Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) {
      AppCubit.get(context).deleteDataBase(id: model["id"]);
    },
    background: Container(
      padding: EdgeInsets.only(right: 50),
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.delete,
        color: Colors.red,
        size: 35,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage("assets/images/pexels-photo-5717425.webp"),
            radius: 40,
            child:
                Text("${model["time"]}", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${model["title"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${model["data"]}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDataBase(status: "done", id: model['id']);
            },
            icon: Icon(
              Icons.check_circle,
              color:
                  model["status"] == "done" ? defaultColor : Colors.grey[300],
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDataBase(status: "archive", id: model['id']);
            },
            icon: Icon(
              Icons.archive_outlined,
              color:
                  model["status"] == "done" ? Colors.grey[300] : defaultColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Future showTaskBody(Map model, context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("${model["title"]}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("${model["body"]}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          FloatingActionButton(
            child: Text("OK"),
            onPressed: () {
              // Do something here
              Navigator.of(context).pop();
            },
          ),
        ],
        contentPadding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      );
    },
  );
}

Widget noteCart(Map model, context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNote(
            id: model["id"],
            title: model["title"],
            body: model["body"],
          ),
        ),
      );
    },
    child: Column(
      children: [
        Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
            width: 150,
            height: 250,
            child: Center(
              child: Text(
                "${model["body"]}",
                style: TextStyle(color: Colors.grey[300]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        Text("${model["title"]}"),
        SizedBox(height: 3),
        Text(
          "${model["data"]}",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

Widget myPopupMenu(context, id) {
  return PopupMenuButton(
    itemBuilder: (BuildContext context) => [
      PopupMenuItem(
        child: Text('Item 1'),
        value: 'Item 1',
      ),
      PopupMenuItem(
        child: Text('Item 2'),
        value: 'Item 2',
      ),
      PopupMenuItem(
        child: Text('Delete'),
        onTap: () {
          Navigator.pop(context);
          AppCubit.get(context).deleteDataBase(id: id);
        },
      ),
    ],
    onSelected: (value) {
      AppCubit.get(context).onChang(value);
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      child: Icon(Icons.more_vert, color: Colors.black, size: 25),
    ),
  );
}

void navigatorTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
