import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/screens/View/Screens/signin_screen.dart';
import 'cubit/cubit/fav_cubit.dart';
import 'cubit/cubit/lap_cubit.dart';
import 'cubit/cubit/auth_cubit.dart';
import 'data/lap_data.dart';
import 'screens/View/Screens/favorite_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavCubit()),
        BlocProvider(create: (_) => LapCubit(LapData())),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        title: 'Laptops Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SignInScreen(),
        debugShowCheckedModeBanner: false,
        routes: {'/favorites': (_) => const FavoritesScreen()},
      ),
    );
  }
}
