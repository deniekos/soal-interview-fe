class GithubListData {
  final String name;
  final String description;
  final int stargazersCount;
  final String language;
  final DateTime updatedAt;
  final String fullName;

  GithubListData({
    required this.name,
    required this.description,
    required this.stargazersCount,
    required this.language,
    required this.updatedAt,
    required this.fullName,
  });

  factory GithubListData.fromJson(Map<String, dynamic> json) {
    return GithubListData(
      name: json['name'],
      description: json['description'] ?? 'No description',
      stargazersCount: json['stargazers_count'],
      language: json['language'] ?? 'Unknown',
      updatedAt: DateTime.parse(json['updated_at']),
      fullName: json['full_name'],
    );
  }
}
