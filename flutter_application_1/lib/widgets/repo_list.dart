import 'package:flutter/material.dart';
import '../models/github_list_data.dart';

/// A reusable card displaying GitHub repository information.
///
/// Supports customization of:
/// - Tap actions ([onTap])
/// - Primary color ([primaryColor])
///
/// Example:
/// ```dart
/// RepoItem(
///   repo: GitHubRepo(...),
///   primaryColor: Colors.green,
///   onTap: () => print("Tapped!"),
/// )
/// ```

class RepoList extends StatelessWidget {
  final GithubListData repo;
  final VoidCallback? onTap;
  final Color? primaryColor;

  const RepoList({
    required this.repo,
    this.onTap,
    this.primaryColor = Colors.blue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                repo.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (repo.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  repo.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (repo.language.isNotEmpty)
                    _buildBadge(repo.language, primaryColor!),
                  const SizedBox(width: 8),
                  _buildBadge("${repo.stargazersCount} stars", Colors.amber),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
