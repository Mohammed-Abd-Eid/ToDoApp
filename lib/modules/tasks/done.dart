// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/componets.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class Done extends StatelessWidget {
  const Done({Key? key}) : super(key: key);

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
                // floating: true,
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
                    'DONE TASK',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  //  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 30,
                    ),
                  ],
                ),
              ),
              SliverReorderableList(
                itemCount: cubit.doneTasks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      key: Key('item_$index'),
                      onTap: () {
                        showTaskBody(cubit.doneTasks[index], context);
                      },
                      child: buildTaskItem(cubit.doneTasks[index], context));
                },
                onReorder: (oldIndex, newIndex) {
                  newIndex;
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
