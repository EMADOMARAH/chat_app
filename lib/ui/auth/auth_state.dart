part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserCreatedSuccessState extends AuthState{}

class FailedToCreateUserState extends AuthState{
  String message;
  FailedToCreateUserState({required this.message});
}

class UserImageSelectedSuccessState extends AuthState{}
class FailedToGetUserImageSelectedState extends AuthState{}

class FailedToSaveUserDataOnFirestoreState extends AuthState{}
class SaveUserDataOnFirestoreSuccessState extends AuthState{}


class RegisterLoadingState extends AuthState{}
class RegisterSuccessState extends AuthState{}

class LoginSuccessState extends AuthState{}
class LoginFailedState extends AuthState{}
class LoginLoadingState extends AuthState{}
