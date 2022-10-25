import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ricknmortyapp/character_details.dart';

import './request_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<RickNMortyResponse> data;

  @override
  void initState() {
    super.initState();
    data = fetchRickNMorty();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(primarySwatch: Colors.cyan, fontFamily: 'Inter'),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Rick & Morty'),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        body: FutureBuilder<RickNMortyResponse>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var results = snapshot.data!.results;
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var character = results[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CharacterCard(character),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Results character;

  const CharacterCard(
    this.character, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetails(character),
        ),
      ),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(character.image!, fit: BoxFit.cover)),
          ListTile(
            // center the title
            title: Text(
              character.name!,
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              character.status!,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
