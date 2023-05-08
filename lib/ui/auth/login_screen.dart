import 'package:chat_app/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is LoginSuccessState) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen()));
            
          }  
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,

                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: () {
                      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                        BlocProvider.of<AuthCubit>(context).login(
                            email: emailController.text, password: passwordController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(backgroundColor: Colors.red, content: Text('Fill with correct data')));
                      }
                    },
                    child: Text(state is LoginLoadingState ? 'Processing...' : 'Login'),
                    minWidth: double.infinity,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
