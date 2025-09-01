class GitHubRepoDetailData {
  final String name;
  final String description;
  final String language;
  final int stargazersCount;
  final int forksCount;
  final String createdAt;
  final String htmlUrl;

  GitHubRepoDetailData({
    required this.name,
    required this.description,
    required this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.createdAt,
    required this.htmlUrl,
  });

  factory GitHubRepoDetailData.fromJson(Map<String, dynamic> json) {
    return GitHubRepoDetailData(
      name: json['name'],
      description: json['description'] ?? 'No description',
      language: json['language'] ?? 'Unknown',
      stargazersCount: json['stargazers_count'],
      forksCount: json['forks_count'],
      createdAt: _formatDate(json['created_at']),
      htmlUrl: json['html_url'],
    );
  }

  // Android Dev Note: Equivalent to DateUtils.formatDateTime()
  static String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day}';
  }
}
