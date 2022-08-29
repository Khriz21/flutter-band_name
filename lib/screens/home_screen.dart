import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routerName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 8),
    Band(id: '2', name: 'Queen', votes: 9),
    Band(id: '3', name: 'Mana', votes: 7),
    Band(id: '3', name: 'Heroes del cilencio', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Center(
          child: Text(
            'Bandas',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, int i) => _bandTitle(
          bands[i],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: _backgrouund(),
      onDismissed: (direction) {
        print('Dirección: $direction');

        bands.removeWhere((element) => element.id == band.id);

        //TODO: Llamar al borrador en el servidor
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  Container _backgrouund() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      color: Colors.red[300],
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
        ),
      ),
    );
  }

  addNewBand() {
    final texController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Nueva banda')),
            content: TextField(
              controller: texController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                onPressed: () => addBand(texController.text),
                child: const Icon(Icons.save, color: Colors.black87),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Nueva banda'),
            content: CupertinoTextField(
              controller: texController,
            ),
            actions: [
              CupertinoDialogAction(
                child: const Icon(Icons.save, color: Colors.black87),
                onPressed: () => addBand(texController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBand(String name) {
    if (name.length > 1) {
      //* Podemos agregar el nombre a la lista
      bands.add(
        Band(id: DateTime.now().toString(), name: name, votes: 2),
      );

      setState(() {});
    }
    Navigator.pop(context);
  }
}
