class GitHubUserData {
  final String login;
  final String name;
  final String bio;
  final String avatarUrl;
  final int publicRepos;

  GitHubUserData({
    required this.login,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.publicRepos,
  });

  factory GitHubUserData.fromJson(Map<String, dynamic> json) {
    return GitHubUserData(
      login: json['login'] as String,
      name: json['name'] as String? ?? 'No name',
      bio: json['bio'] as String? ?? 'No bio',
      avatarUrl: json['avatar_url'] as String,
      publicRepos: json['public_repos'] as int,
    );
  }
}
