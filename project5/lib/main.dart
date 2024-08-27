import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const AlbumList(),
    );
  }
}

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  _AlbumList createState() => _AlbumList();
}

class _AlbumList extends State<AlbumList> {
  final TextEditingController tec = TextEditingController();
  Widget currWid = const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('Add an album to get started!!'),
  );

  final Map<int, Album> listAlbum = <int, Album>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Json Parser"),
      ),
      body: currWid,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          fetchAlbum(int.parse(tec.text));
          tec.clear();
        },
        tooltip: 'Get',
        label: SizedBox(
          width: 150,
          child: TextField(
            controller: tec,
            keyboardType: TextInputType.number,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter Album ID'),
          ),
        ),
        icon: const Icon(Icons.search),
      ),
    );
  }

  void fetchAlbum(int id) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Album a = Album.fromJson(jsonDecode(response.body));
      setState(() {
        listAlbum[a.id] = a;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text('That album does not exist'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  ),
                ],
              ));
    }
    currWid = ListView(
      children: getList(),
    );
  }

  List<AlbumCard> getList() {
    List<AlbumCard> ret = [];
    for (MapEntry<int, Album> me in listAlbum.entries) {
      Album a = me.value;
      ret.add(AlbumCard(
        userId: a.userId,
        id: a.id,
        title: a.title,
      ));
    }
    return ret;
  }
}

class AlbumCard extends StatelessWidget {
  const AlbumCard(
      {super.key, required this.userId, required this.id, required this.title});

  final int userId, id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.inversePrimary,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Album number $id",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Album title: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text('\t\t\t\t\t\t\t$title'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Album ID: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '\t\t\t\t\t\t\t  $id',
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Album userID: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text('\t\t$userId'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
