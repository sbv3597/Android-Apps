import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:videochat/Models/message.dart';

class SocketUtils {
  static String _connectUrl = 'https://secretchat-flutter.herokuapp.com/';
  SocketIO _socket;
  SocketIOManager _manager;
  String _fromUser;
  static const String ON_MESSAGE_RECEIVED = 'receive_message';
  static const String SUB_EVENT_MESSAGE_SENT = 'message_sent_to_user';

  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';
  initSocket(String fromUser) async {
    print('Connecting user: $fromUser');
    this._fromUser = fromUser;
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  _socketOptions() {
    print('connection params ');
    final Map<String, String> userMap = {
      'from_user': _fromUser,
    };
    return SocketOptions(
      _connectUrl,
      enableLogging: true,
      transports: [Transports.WEB_SOCKET],
      query: userMap,
    );
  }

  connectToSocket() {
    if (null == _socket) {
      print("Socket is Null");
      return;
    }
    print("Connecting to socket...");
    _socket.connect();
  }

  sendSingleChatMessage(Chat chatMessageModel) {
    if (null == _socket) {
      print("Socket is Null, Cannot send message");
      return;
    }
    _socket.emit("single_chat_message", [chatMessageModel.toJson()]);
  }

  closeConnection() {
    if (null != _socket) {
      print("Close Connection");
      _manager.clearInstance(_socket);
    }
  }

  setConnectListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    _socket.onConnectError((data) {
      onConnectError(data);
    });
  }

  setOnConnectionErrorTimeOutListener(Function onConnectTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectTimeout(data);
    });
  }

  setOnErrorListener(Function onError) {
    _socket.onError((error) {
      onError(error);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket.onDisconnect((data) {
      print("onDisconnect $data");
      onDisconnect(data);
    });
  }

  setOnMessageBackFromServer(Function onMessageBackFromServer) {
    _socket.on(SUB_EVENT_MESSAGE_FROM_SERVER, (data) {
      onMessageBackFromServer(data);
    });
  }

  setOnChatMessageReceivedListener(Function onChatMessageReceived) {
    _socket.on(ON_MESSAGE_RECEIVED, (data) {
      print("Received $data");
      onChatMessageReceived(data);
    });
  }
}
