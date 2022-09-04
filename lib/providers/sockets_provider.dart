import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, ofline, connecting }

class SocketProvider with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  io.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket!;

  Function get emit => _socket!.emit;

  SocketProvider() {
    _initConfig();
  }

  // IP de la casa de ma vie
  final String url = 'http://192.168.1.26:3001';
  // final String url = 'http://192.168.1.13:3001/';

  void _initConfig() {
    // Dart client
    _socket = io.io(url, {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.ofline;
      notifyListeners();
    });
  }
}
