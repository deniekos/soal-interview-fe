import 'package:flutter/material.dart';
import '../models/github_detail_data.dart';
import '../services/github_detail.dart';

class RepoDetailScreen extends StatefulWidget {
  final String fullName;

  const RepoDetailScreen({required this.fullName, super.key});

  @override
  State<RepoDetailScreen> createState() => _RepoDetailScreenState();
}

class _RepoDetailScreenState extends State<RepoDetailScreen> {
  final _api = GithubDetailApiCall();
  GitHubRepoDetailData? _repoDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRepoDetail();
  }

  Future<void> _loadRepoDetail() async {
    try {
      final detail = await _api.fetchRepoDetail(widget.fullName);
      setState(() {
        _repoDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error Log ${e.toString()}");
      setState(() {
        _error = e.toString().contains('404')
            ? "Repository not found"
            : "Failed to load details";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fullName)),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    return _repoDetail != null ? _buildDetail() : const SizedBox();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Error: $_error",
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: _loadRepoDetail, child: const Text("Retry")),
        ],
      ),
    );
  }

  Widget _buildDetail() {
    final repo = _repoDetail!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Text(
            repo.name,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (repo.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              repo.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatBadge("⭐ ${repo.stargazersCount} Stars", Colors.amber),
              _buildStatBadge("🍴 ${repo.forksCount} Forks", Colors.blue),
              _buildStatBadge("📅 Created: ${repo.createdAt}", Colors.green),
              if (repo.language.isNotEmpty)
                _buildStatBadge("💻 ${repo.language}", Colors.purple),
            ],
          ),
          const SizedBox(height: 24),

          // GitHub link
          _buildGitHubLink(),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGitHubLink() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.link, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.fullName,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
