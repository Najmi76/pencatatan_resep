import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resep/consent/appbar.dart';
import 'package:resep/consent/colors.dart';
import 'package:resep/models/class.dart';
import 'package:resep/screen/recipe.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexx = 0;
  List<Kategori> category = [];
  List<Resep> food = [];

  CollectionReference penandaCollection =
      FirebaseFirestore.instance.collection('penanda');

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _fetchKategori();
    _fetchResep();
  }

  Future<void> _fetchResep() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Resep').get();

    List<Resep> resepList = [];
    snapshot.docs.forEach((doc) {
      resepList.add(Resep.FromMap(doc.data() as Map<String, dynamic>));
    });

    setState(() {
      food = resepList;
    });
  }

  Future<void> _fetchKategori() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('kategori').get();

    List<Kategori> kategoriList = [];
    snapshot.docs.forEach((doc) {
      kategoriList.add(Kategori.FromMap(doc.data() as Map<String, dynamic>));
    });

    setState(() {
      category = kategoriList;
    });
  }

  Future<void> _addPenanda(Resep resep) async {
    await penandaCollection.add({
      'id_penanda':
          resep.id_resep, // Assuming the recipe has an "id_resep" field
      'penanda': resep.deskripsi,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 20,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: ListView.builder(
                      itemCount: category.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category[index].id_kategori;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: index == 0 ? 4 : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selectedCategory == category[index].id_kategori ? maincolor : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: selectedCategory == category[index].id_kategori
                                        ? maincolor
                                        : Colors.transparent,
                                    offset: selectedCategory== category[index].id_kategori
                                        ? Offset(1, 1)
                                        : Offset(0, 0),
                                    blurRadius: selectedCategory == category[index].id_kategori ? 7 : 0,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  child: Text(
                                    category[index].nama_kategori,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          selectedCategory == category[index].id_kategori ? Colors.white : font,
                                      fontFamily: 'ro',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'Daftar Resep',
                        style: TextStyle(
                          fontSize: 20,
                          color: font,
                          fontFamily: 'ro',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => resep(
                                  resepdata: {
                                    "nama_resep": food[index].nama_resep,
                                    "image": food[index].image,
                                    "bahan": food[index].bahan,
                                    "step": food[index].deskripsi
                                  },
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 185, 185, 185),
                            offset: Offset(1, 1),
                            blurRadius: 15,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _addPenanda(food[index]);
                                  },
                                  child: Icon(Icons.favorite_border),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                image: food[index].image != null
                                  ? DecorationImage(
                                      image: FileImage(File(food[index].image)),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage('https://vocasia.id/blog/wp-content/uploads/2022/01/error-404-not-found.png'),
                                      fit: BoxFit.cover,
                                    ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            food[index].deskripsi,
                            style: TextStyle(
                              fontSize: 18,
                              color: font,
                              fontFamily: 'ro',
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
                childCount: selectedCategory.isEmpty ? food.length : food.where((resep) => resep.id_kategori == selectedCategory).length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
