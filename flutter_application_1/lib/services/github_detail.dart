import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/github_detail_data.dart';

class GithubDetailApiCall {
  Future<GitHubRepoDetailData> fetchRepoDetail(String fullName) async {
    final url = '${dotenv.env['GITHUB_API_BASE']!}repos/$fullName';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'Flutter-GitHub-Login-App'},
    );

    if (response.statusCode == 200) {
      return GitHubRepoDetailData.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load repo detail (Status: ${response.statusCode})',
      );
    }
  }
}
