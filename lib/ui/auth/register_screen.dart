import 'package:chat_app/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is FailedToCreateUserState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('${state.message}')));
            }
            if (state is UserCreatedSuccessState) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocProvider.of<AuthCubit>(context).userImgFile != null
                      ? Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(BlocProvider.of<AuthCubit>(context).userImgFile!),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<AuthCubit>(context).getImage();
                                },
                                child: Text(
                                  'Change Photo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).getImage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text('Select Photo')
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        BlocProvider.of<AuthCubit>(context).register(
                            email: emailController.text, name: nameController.text, password: passwordController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(backgroundColor: Colors.red, content: Text('Fill with correct data')));
                      }
                    },
                    child: Text(state is RegisterLoadingState ? 'Processing...' :'Sign Up'),
                    minWidth: double.infinity,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
