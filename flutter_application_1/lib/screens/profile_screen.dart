import 'package:flutter/material.dart';
import '../models/github_user_data.dart';
import '../models/github_list_data.dart';
import '../services/github_list.dart';
import '../widgets/repo_list.dart';
import '../screens/repo_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final GitHubUserData user;
  const ProfileScreen({required this.user, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = GithubListApiCall();
  List<GithubListData> _repos = [];
  bool _isLoadingRepos = true;
  String? _repoError;

  @override
  void initState() {
    super.initState();
    _loadRepos();
  }

  Future<void> _loadRepos() async {
    try {
      final repos = await _api.fetchRepos(widget.user.login);
      setState(() {
        _repos = repos;
        _isLoadingRepos = false;
      });
    } catch (e) {
      setState(() {
        _repoError = e.toString().contains('403')
            ? "API rate limit exceeded"
            : "Failed to load repositories";
        _isLoadingRepos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.login)),
      body: SafeArea(child: _buildProfileContent()),
    );
  }

  // Widget _buildProfileContent() {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           _buildUserProfile(),
  //           const SizedBox(height: 24),
  //           _buildRepoSection(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProfileContent() {
    return Column(
      children: [
        _buildUserProfile(),
        const SizedBox(height: 24),
        const SizedBox(height: 12),
        Expanded(child: _buildRepoList()),
      ],
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(widget.user.avatarUrl),
        ),
        const SizedBox(height: 16),
        Text(
          widget.user.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          widget.user.bio,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "${widget.user.publicRepos} Public Repositories",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildRepoList() {
    if (_isLoadingRepos) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_repoError != null) {
      return _buildErrorWidget();
    }
    if (_repos.isEmpty) {
      return const Center(child: Text("No repositories found"));
    }
    return _buildRepoListView();
  }

  Widget _buildErrorWidget() {
    return Column(
      children: [
        Text("Error: $_repoError", style: const TextStyle(color: Colors.red)),
        TextButton(onPressed: _loadRepos, child: const Text("Retry")),
      ],
    );
  }

  Widget _buildRepoListView() {
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      itemCount: _repos.length,
      itemBuilder: (context, index) {
        final repo = _repos[index];
        return RepoList(repo: repo, onTap: () => _navigateToRepoDetail(repo));
      },
    );
  }

  void _navigateToRepoDetail(GithubListData data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepoDetailScreen(fullName: data.fullName),
      ),
    );
  }
}
