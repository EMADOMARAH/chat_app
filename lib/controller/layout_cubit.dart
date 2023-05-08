import 'package:bloc/bloc.dart';
import 'package:chat_app/controller/layout_states.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit() : super(LayoutInitialState());

  USerModel? userModel ;

  void getMyData()async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(Constants.userID!).get().then((value) {
        userModel = USerModel.fromJson(data: value.data()!);
      });
      emit(GetMyDataSuccessState());
    }on FirebaseException catch(e){
      emit(FailedGetMyDataState());
    }
  }


  List<USerModel>users = [];

  void getUsers()async{
    users.clear();
    emit(GetUsersDataLoadingState());
    try{
      await FirebaseFirestore.instance.collection('Users').get().then((value){
        for(var item in value.docs){
          if (item.id != Constants.userID) {
            users.add(USerModel.fromJson(data: item.data()));
          }
        }
        emit(GetUsersDataSuccessState());
      });
    } on FirebaseException catch(e){
      users = [];
      emit(FailedGetUsersDataState());
    }
  }


  List<USerModel> usersFiltered = [];
  void searchUser({required String query}){
    usersFiltered = users.where((element) => element.name!.toLowerCase().startsWith(query.toLowerCase())).toList();
    emit(FilteredUsersSuccessState());
  }


  bool searchEnabled = false ;
  void changeSearchStatus(){
    searchEnabled = !searchEnabled ;
    if (searchEnabled == false) {
      usersFiltered.clear();
    }
    emit(ChangeSearchStatusSuccessState());
  }


  void sendMessage({required String message , required String receiverID})async{

    //save data on my document
    MessageModel messageModel = MessageModel(message, DateTime.now().toString(), Constants.userID);

    await FirebaseFirestore.instance.collection("Users").doc(Constants.userID).collection("Chat")
        .doc(receiverID).collection("Messages").add(messageModel.toJson());


    //save data on receiver document
    await FirebaseFirestore.instance.collection("Users").doc(receiverID).collection("Chat").doc(Constants.userID)
    .collection("Messages").add(messageModel.toJson());
    emit(SendMessageSuccessState());
  }


  List<MessageModel> messages =[];

  void getMessages({required String receiverId}){
    emit(GetMessagesLoadingState());
    FirebaseFirestore.instance.collection("Users").doc(Constants.userID).collection("Chat")
        .doc(receiverId).collection("Messages").orderBy('date').snapshots().listen((event) {
      messages.clear();

      for(var item in event.docs){
            messages.add(MessageModel.fromJson(data: item.data()));
          }
          emit(GetMessagesSuccessState());
    });

  }


}