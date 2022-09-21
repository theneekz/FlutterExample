import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchPlayersForYear({String year = '2019'}) async {
  var data;
  var url = 'https://www.fantasyfootballdatapros.com/api/players/$year/all';
  try {
    final res = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    data = jsonDecode(res.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<Map> getAllTeamsData() async {
  var teams = {};
  try {
    var rawData = await fetchPlayersForYear();
    for (final player in rawData) {
      var thisTeam = player['team'];
      if (teams.containsKey(thisTeam)) {
        teams[thisTeam]['players'].add(player);
      } else {
        teams[thisTeam] = {
          'players': [player],
          'name': thisTeam
        };
      }
    }
    return teams;
  } catch (e) {
    throw e;
  }
}
