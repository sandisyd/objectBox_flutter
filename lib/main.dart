import 'dart:developer';

import 'package:coba_object_box/entities/objectbox.dart';
import 'package:coba_object_box/entities/person.dart';
import 'package:coba_object_box/objectbox.g.dart';
import 'package:flutter/material.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  store = (await ObjectBox.create()).store;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  TextEditingController i = TextEditingController();
  final Box<Person> personBox = store.box<Person>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Box CRUD"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: i,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Input",
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  personBox.put(Person(name: i.text));
                },
                child: Text("Create"),
              ),
              MaterialButton(
                onPressed: () {
                  for (var element in personBox.getAll()) {
                    log("${element.id} - ${element.name}");
                  }
                },
                child: Text("Read"),
              ),
              MaterialButton(
                onPressed: () {
                  List<String> s = i.text.split("-");
                  if (s.length == 2) {
                    int id = int.tryParse(s[0]) ?? 0;
                    if (id > 0) {
                      personBox.put(Person(id: id, name: s[1]));
                    }
                  }
                },
                child: Text("Update"),
              ),
              MaterialButton(
                onPressed: () {
                  int id = int.tryParse(i.text) ?? 0;
                  if (id > 0) {
                    log("${personBox.remove(id)}");
                  }
                },
                child: Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
