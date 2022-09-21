import 'api.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'All Teams'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
        future: getAllTeamsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data is Map<dynamic, dynamic>) {
            return Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text(widget.title),
                ),
                body: AllTeamsView(items: snapshot.data!));
          } else {
            return const CircularProgressIndicator();
          }
          ;
        });
  }
}

class AllTeamsView extends StatelessWidget {
  const AllTeamsView({super.key, required this.items});
  final Map items;

  @override
  Widget build(BuildContext context) {
    void navigateToTeam(Map team) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            return Team(team: team);
          },
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, i) {
        var key = items.keys.elementAt(i);
        return ListTile(
            title: Text(items[key]['name']),
            onTap: () => navigateToTeam(items[key]));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key, required this.team});
  final Map team;
  @override
  Widget build(BuildContext context) {
    void navigateToStats(Map player) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            return Stats(stats: player);
          },
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(team['name']),
        ),
        body: ListView.separated(
          itemCount: team['players'].length,
          itemBuilder: (context, i) {
            String fullName = team['players'][i]['player_name'];
            return ListTile(
              title: Text(fullName),
              onTap: () => navigateToStats(team['players'][i]),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }
}

class Stats extends StatelessWidget {
  const Stats({super.key, required this.stats});
  final Map stats;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Text.rich(TextSpan(
            text: jsonEncode(stats),
            style: DefaultTextStyle.of(context).style)));
  }
}
