import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resep/consent/appbar.dart';
import 'package:resep/models/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Penanda> favoritereseps = [];
  String idcoba = '';

  @override
  void initState() {
    super.initState();
    _fetchPenanda();
  }

  Future<void> _fetchPenanda() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('penanda').get();

    List<Penanda> penandaList = [];
    snapshot.docs.forEach((doc) {
      penandaList.add(Penanda(
        id_penanda: doc['id_penanda'],
        penanda: doc['penanda'],
      ));
    });

    setState(() {
      favoritereseps = penandaList;
    });
  }

  Future<void> deleteItem(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference adminCollection =
        FirebaseFirestore.instance.collection('penanda');
    return adminCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Favorite reseps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: favoritereseps.length,
                itemBuilder: (context, index) {
                  final resepName = favoritereseps[index].penanda;
                  return GestureDetector(
                    onTap: () {
                      // TODO: Navigate to resep details page
                    },
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          // leading: CircleAvatar(
                          //   radius: 30,
                          //   backgroundImage: FileImage(File()),
                          // ),
                          title: Text(
                            resepName,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Penanda'),
                                    content: Text(
                                        'Are you sure you want to delete this penanda?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          deleteItem(
                                              favoritereseps[index].id_penanda);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
