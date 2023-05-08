import 'package:chat_app/controller/layout_cubit.dart';
import 'package:chat_app/controller/layout_states.dart';
import 'package:chat_app/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = BlocProvider.of<LayoutCubit>(context)
      ..getMyData()
      ..getUsers();
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (layoutCubit.userModel != null)
                    UserAccountsDrawerHeader(
                      accountName: Text(layoutCubit.userModel!.name!),
                      accountEmail: Text(layoutCubit.userModel!.email!),
                      currentAccountPicture: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(layoutCubit.userModel!.imageURL!),
                      ),
                    ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Log out'),
                          )
                        ],


                      ))
                ],
              ),
            ),
            appBar: AppBar(
              title: layoutCubit.searchEnabled ? TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (input){
                  layoutCubit.searchUser(query: input);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search User',
                  hintStyle: TextStyle(color: Colors.white)
                ),
              ) : GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: ListTile(
                    leading: Icon(Icons.menu),
                    title: Text('Chat'),
                  ),
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    child: Icon(
                      layoutCubit.searchEnabled? Icons.clear : Icons.search
                    ),
                    onTap: (){
                      layoutCubit.changeSearchStatus();
                    },
                  ),
                )
              ],
            ),
            body: state is GetUsersDataLoadingState ?
            Center(
              child: CircularProgressIndicator(),
            ) : layoutCubit.users.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 12,);
                  },
                  itemCount: layoutCubit.usersFiltered.isEmpty ? layoutCubit.users.length : layoutCubit.usersFiltered.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ChatScreen(uSerModel: layoutCubit.usersFiltered.isEmpty? layoutCubit.users[index] : layoutCubit.usersFiltered[index]);
                        }));
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            layoutCubit.usersFiltered.isEmpty ? layoutCubit.users[index].imageURL!:layoutCubit.usersFiltered[index].imageURL!
                        ),
                      ),
                      title: Text(layoutCubit.usersFiltered.isEmpty ? layoutCubit.users[index].name!:layoutCubit.usersFiltered[index].name!),
                    );
                  }

              ),
            ) : Center(
              child: Text('There is No Users Yet'),
            )
        );
      },
    );
  }
}
