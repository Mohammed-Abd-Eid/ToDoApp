// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/shared/components/componets.dart';
import 'package:fluttertest/shared/cubit/states.dart';

import '../../shared/cubit/cubit.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                bottom: Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.menu, color: Colors.black),
                        Spacer(),
                        Icon(Icons.picture_as_pdf_outlined,
                            color: Colors.black),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: 300.0,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,

                  title: Text(
                    'All Notes',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  //  centerTitle: true,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                SizedBox(
                  height: 30,
                )
              ])),
              SliverGrid.builder(
                itemBuilder: (context, index) {
                  return noteCart(cubit.notes[index], context);
                },
                itemCount: cubit.notes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 5.5,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 5,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  height: 300,
                )
              ])),
            ],
          ),
        );
      },
    );
  }
}
