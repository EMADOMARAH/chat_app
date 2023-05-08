import 'package:chat_app/controller/layout_cubit.dart';
import 'package:chat_app/ui/auth/login_screen.dart';
import 'package:chat_app/ui/auth/register_screen.dart';
import 'package:chat_app/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  //to make sure to run firebase iniat first
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPref = await SharedPreferences.getInstance();
  Constants.userID = sharedPref.getString('userID');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home:Constants.userID != null ? HomeScreen() : RegisterScreen(),
      ),
    );
  }
}


