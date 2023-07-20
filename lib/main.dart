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
                  List<String> strings = i.text.split("-");

                  if (strings.length == 2) {
                    personBox.put(Person(
                        nationalIdNumber:
                            DateTime.now().microsecondsSinceEpoch.toString(),
                        name: strings[0],
                        age: int.parse(strings[1])));
                  }
                },
                child: Text("Create"),
              ),
              MaterialButton(
                onPressed: () {
                  for (var o in personBox.getAll()) {
                    log('${o.personId} | ${o.nationalIdNumber} | ${o.name} | ${o.age}');
                  }
                },
                child: Text("Read"),
              ),
              MaterialButton(
                onPressed: () {
                  QueryBuilder<Person> builder = personBox
                      .query(Person_.name
                          .startsWith("A")
                          .or(Person_.age.equals(19)))
                      .order(Person_.name, flags: Order.descending);

                  Query<Person> query = builder.build();

                  log(query.describeParameters());
                  for (var x in query.find()) {
                    log('${x.personId} | ${x.nationalIdNumber} | ${x.name} | ${x.age}');
                  }
                },
                child: Text("Query"),
              ),
              MaterialButton(
                onPressed: () {
                  personBox.removeAll();
                },
                child: Text("Delete All"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
