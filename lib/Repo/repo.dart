import 'dart:convert';
import 'package:practice/Module/member.dart';
import '../Module/member.dart';
import 'package:http/http.dart' as http;

class NetWorkRepo {
  Future<List<Member>> loadData(String query, int page) async {
    var members = <Member>[];
    String dataURL = "https://api.github.com/search/users?q=$query&page=$page";
    http.Response response = await http.get(Uri.parse(dataURL));
    final Map membersJSON = json.decode(response.body);
    for (var memberJSON in membersJSON.values.last) {
      final member = new Member(memberJSON["login"], memberJSON["avatar_url"]);
      members.add(member);
    }
    return members;
  }
}