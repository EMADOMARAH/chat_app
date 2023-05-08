class MessageModel {
  String? content;
  String? date;
  String? senderId;

  MessageModel(this.content, this.date, this.senderId);

  //refactoring map|json
  MessageModel.fromJson({required Map<String, dynamic> data}) {
    content = data['content'];
    date = data['date'];
    senderId = data['senderId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'senderId': senderId,
    };
  }
}
