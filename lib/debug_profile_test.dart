import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/cubit/cubit/auth_cubit.dart';
import 'package:product_api_app/screens/View/Screens/profile_page.dart';

void main() {
  runApp(const DebugProfileApp());
}

class DebugProfileApp extends StatelessWidget {
  const DebugProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debug Profile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: const ProfilePage(),
      ),
    );
  }
}
