import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AlbumCubit ac = AlbumCubit();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (_) => ac,
          child: AlbumList(ac: ac),
        ));
  }
}

class AlbumList extends StatefulWidget {
  const AlbumList({super.key, required this.ac});

  final AlbumCubit ac;

  @override
  _AlbumList createState() => _AlbumList(ac: ac);
}

class _AlbumList extends State<AlbumList> {
  final TextEditingController tec = TextEditingController();

  _AlbumList({required this.ac});

  final AlbumCubit ac;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Json Parser"),
      ),
      body: BlocBuilder<AlbumCubit, Map<int, Album>>(
        bloc: ac,
        builder: (context, map) => getList(map),
        buildWhen: (mapold, mapnew) {
          return mapold.length == mapnew.length;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ac.fetchAlbum(int.parse(tec.text), context);
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

  Widget getList(Map<int, Album> listAlbum) {
    print('here');
    if (listAlbum.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Add an album to get started!!'),
      );
    }
    List<AlbumCard> ret = [];
    for (MapEntry<int, Album> me in listAlbum.entries) {
      Album a = me.value;
      ret.add(AlbumCard(
        a: a,
        ac: ac,
      ));
    }

    return ListView(
      children: ret,
    );
  }
}

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.a, required this.ac});

  final Album a;
  final AlbumCubit ac;

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
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ac.removeAlbum(a.id);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Album number ${a.id}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  width: 100,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumScreen(a: a),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key, required this.a});

  final Album a;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.inversePrimary.withRed(50),
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Album number ${a.id}",
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
                  'This album\'s title is: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text('\t\t\t\t\t\t\t\t\t\t\t\t${a.title}'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This album\'s id is: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '\t\t\t\t\t\t\t\t\t\t\t\t\t  ${a.id}',
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This album was created \nby the user with id: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text('\t\t\t\t\t${a.userId}'),
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

class AlbumCubit extends Cubit<Map<int, Album>> {
  AlbumCubit() : super({});

  void fetchAlbum(int id, BuildContext context) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Album a = Album.fromJson(jsonDecode(response.body));
      state[a.id] = a;
      for (MapEntry me in state.entries) {
        print(me.toString());
      }
      emit(state);
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
        ),
      );
    }
    emit(state);
  }

  void removeAlbum(int id) {
    state.remove(id);
    emit(state);
  }
}
