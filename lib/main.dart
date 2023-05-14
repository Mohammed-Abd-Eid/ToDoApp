// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/shared/bloc_observer.dart';
import 'package:fluttertest/shared/cubit/cubit.dart';
import 'package:fluttertest/shared/network/local/notification.dart';
import 'package:fluttertest/shared/styles/them.dart';

import 'layout/home_layout.dart';
import 'modules/home/onBoarding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // constructor
  // build

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..createDataBase()
        ..initializeTimeZones(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnBoarding(),
        routes: {
          HomeLayout.routeName: (ctx) => HomeLayout(),
        },
        theme: lightTheme,
      ),
    );
  }
}
