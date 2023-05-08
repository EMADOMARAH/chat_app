import 'package:chat_app/controller/layout_cubit.dart';
import 'package:chat_app/controller/layout_states.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final USerModel uSerModel;

  final messageController = TextEditingController();

  ChatScreen({Key? key, required this.uSerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context)..getMessages(receiverId: uSerModel.id!);
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SendMessageSuccessState) {
          messageController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(uSerModel.name!),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              children: [
                Expanded(
                    child: state is GetMessagesLoadingState
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : cubit.messages.isNotEmpty
                            ? ListView.builder(
                                itemCount: cubit.messages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.blueGrey,
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    child: Text(cubit.messages[index].content!),
                                  );
                                })
                            : Center(
                                child: Text('No Messages Yet.....'),
                              )),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.send),
                      onTap: () {
                        //send msg to FireStore
                        cubit.sendMessage(message: messageController.text, receiverID: uSerModel.id!);
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
