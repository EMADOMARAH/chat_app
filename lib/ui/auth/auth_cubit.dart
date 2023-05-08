import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/core/constants.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  File? userImgFile;
  void getImage()async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage !=null) {
      userImgFile = File(pickedImage.path);
      emit(UserImageSelectedSuccessState());
    }else{
      emit(FailedToGetUserImageSelectedState());
    }
  }

  //register
  void register({required String email,required String name, required String password}) async {
    emit(RegisterLoadingState());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid != null) {
        debugPrint("User Created Success With uid : ${userCredential.user?.uid} ");
        String imaUrl = await uploadImageToStorage();
        await sendUserDataToFirestore(name: name, email: email, password: password, userID: userCredential.user!.uid,imgUrl: imaUrl);
        emit(UserCreatedSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Failed To create user...${e.code}");
      emit(FailedToCreateUserState(message: e.code));
    }
  }


  Future<String> uploadImageToStorage()async{
    Reference imageRef = FirebaseStorage.instance.ref(basename(userImgFile!.path));
    await imageRef.putFile(userImgFile!);
    return await imageRef.getDownloadURL();
  }

  Future<void> sendUserDataToFirestore({required String name ,required String imgUrl, required String email , required String password,required String userID})async{
   USerModel uSerModel = USerModel(name, imgUrl, email, userID, password);
    try{
      await FirebaseFirestore.instance.collection('Users').doc(userID).set(uSerModel.toJson());
      emit(SaveUserDataOnFirestoreSuccessState());

    }on FirebaseException catch(e){
      emit(FailedToSaveUserDataOnFirestoreState());
    }

    emit(RegisterSuccessState());
  }


  void login({required String email ,required String password })async{
    emit(LoginLoadingState());
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user?.uid != null) {
        //save id cache
        final sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString('userID', userCredential.user!.uid);
        Constants.userID = sharedPref.getString('userID');
        emit(LoginSuccessState());
      }
    }on FirebaseAuthException catch(e){
      emit(LoginFailedState());

    }

  }

}
