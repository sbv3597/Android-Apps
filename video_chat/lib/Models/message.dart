import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat(
      {this.chatId,
      this.toUser,
      this.fromUser,
      this.message,
      this.chatType,
      this.userStatusActive,
      this.datetime,
      this.candidate}) {
    if (datetime == null) {
      this.datetime = DateTime.now();
    }
  }

  String chatId;
  String toUser;
  String fromUser;
  String message;
  String chatType;
  bool userStatusActive;
  DateTime datetime;
  String candidate;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatId: json["chat_Id"],
        toUser: json["to_user"],
        fromUser: json["from_user"],
        message: json["message"],
        chatType: json["chat_type"],
        userStatusActive: json["user_status_active"],
        datetime: DateTime.parse(json["datetime"]),
        candidate: json["candidate"],
      );

  Map<String, dynamic> toJson() => {
        "chat_Id": chatId,
        "to_user": toUser,
        "from_user": fromUser,
        "message": message,
        "chat_type": chatType,
        "user_status_active": userStatusActive,
        "datetime": datetime.toIso8601String(),
        "candidate": candidate,
      };
}
