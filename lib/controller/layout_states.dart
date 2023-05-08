abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class GetMyDataSuccessState extends LayoutStates {}

class FailedGetMyDataState extends LayoutStates {}

class GetUsersDataSuccessState extends LayoutStates {}

class FailedGetUsersDataState extends LayoutStates {}

class GetUsersDataLoadingState extends LayoutStates {}

class FilteredUsersSuccessState extends LayoutStates {}

class ChangeSearchStatusSuccessState extends LayoutStates {}

class SendMessageSuccessState extends LayoutStates {}
class SendMessageFailedState extends LayoutStates {}



class GetMessagesSuccessState extends LayoutStates {}

class GetMessagesFailedState extends LayoutStates {}
class GetMessagesLoadingState extends LayoutStates {}