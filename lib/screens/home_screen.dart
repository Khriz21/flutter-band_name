import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_name/providers/providers.dart';
import 'package:band_name/models/models.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routerName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metalica', votes: 8),
    // Band(id: '2', name: 'Queen', votes: 9),
    // Band(id: '3', name: 'Mana', votes: 7),
    // Band(id: '3', name: 'Heroes del cilencio', votes: 1),
  ];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketProvider.serverStatus == ServerStatus.online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),

      //
      body: Column(
        children: [
          //? Llamado a las gráficas
          _showGraph(),

          //* Lista de bandas
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTitle(
                bands[i],
              ),
            ),
          ),
        ],
      ),

      //? Botón flotante.
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      background: _backgrouund(),
      onDismissed: (direction) =>
          socketProvider.emit('delete-band', {"id": band.id}),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            band.name!.substring(0, 2),
          ),
        ),
        title: Text(band.name!),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          socketProvider.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  Container _backgrouund() => Container(
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

  addNewBand() {
    final texController = TextEditingController();

    Platform.isAndroid
        ?
        //* Diálogo para android
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
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
            ),
          )
        :
        //* Diálogo para IOS
        showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
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
                ),
              ],
            ),
          );
  }

  //?Funcion para agregar la nueva banda
  void addBand(String name) {
    if (name.length > 1) {
      final socketProvider = Provider.of<SocketProvider>(
        context,
        listen: false,
      );

      socketProvider.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};

    for (var band in bands) {
      dataMap.putIfAbsent(band.name!, () => band.votes!.toDouble());
    }

    final gradientList = <List<Color>>[
      [
        const Color.fromRGBO(223, 250, 92, 1),
        const Color.fromRGBO(129, 250, 112, 1),
      ],
      [
        const Color.fromRGBO(129, 182, 205, 1),
        const Color.fromRGBO(91, 253, 199, 1),
      ],
      [
        const Color.fromRGBO(175, 63, 62, 1.0),
        const Color.fromRGBO(254, 154, 92, 1),
      ]
    ];

    return SizedBox(
      width: double.infinity,
      height: 250,
      child: dataMap.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: PieChart(
                dataMap: dataMap,
                legendOptions: const LegendOptions(
                    legendTextStyle: TextStyle(fontSize: 9)),
                chartValuesOptions: const ChartValuesOptions(
                  chartValueBackgroundColor: Color.fromRGBO(0, 0, 0, 0),
                ),
                chartType: ChartType.ring,
                gradientList: gradientList,
                emptyColorGradient: const [
                  Color(0xff6c5ce7),
                  Colors.blue,
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
