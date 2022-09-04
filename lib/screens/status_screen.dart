import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_name/providers/providers.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  static const routerName = 'status';

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${socketProvider.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketProvider.emit('emit-message',
              {'name': 'Flutter', 'message': 'Hola desde flutter'});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
