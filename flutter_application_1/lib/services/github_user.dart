import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/github_user_data.dart';

class GitHubUserCall {
  Future<GitHubUserData> fetchUser(String username) async {
    final url = '${dotenv.env['GITHUB_API_BASE']!}users/$username';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'Flutter-GitHub-Login-App'},
    );

    if (response.statusCode == 200) {
      return GitHubUserData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user (Status: ${response.statusCode})');
    }
  }
}
