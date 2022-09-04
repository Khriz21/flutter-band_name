import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_name/providers/providers.dart';
import 'package:band_name/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: HomeScreen.routerName,
        routes: {
          HomeScreen.routerName: (_) => const HomeScreen(),
          StatusScreen.routerName: (_) => const StatusScreen(),
        },
      ),
    );
  }
}
