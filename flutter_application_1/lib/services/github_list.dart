import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/github_list_data.dart';

class GithubListApiCall {
  Future<List<GithubListData>> fetchRepos(String username) async {
    final url =
        '${dotenv.env['GITHUB_API_BASE']!}users/$username/repos?per_page=10';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'Flutter-GitHub-Login-App'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((item) => GithubListData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load repos (Status: ${response.statusCode})');
    }
  }
}
