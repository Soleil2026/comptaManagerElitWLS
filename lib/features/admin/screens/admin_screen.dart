import 'package:flutter/material.dart';
import 'package:compta_manager/core/theme/app_theme.dart';
import 'package:compta_manager/data/database/database_helper.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
            Tab(icon: Icon(Icons.security), text: 'Sécurité'),
            Tab(icon: Icon(Icons.history), text: 'Audit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _UsersTab(),
          _SecurityTab(),
          _AuditTab(),
        ],
      ),
    );
  }
}

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseHelper.instance.query('users');
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_users.length} utilisateur(s)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _users.isEmpty
              ? const Center(child: Text('Aucun utilisateur'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            user['username'][0].toString().toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user['full_name'] ?? user['username']),
                        subtitle: Text(user['email']),
                        trailing: Chip(
                          label: Text(
                            user['role'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _getRoleColor(user['role']),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Administrateur':
        return Colors.red.shade100;
      case 'Expert-comptable':
        return Colors.blue.shade100;
      case 'Collaborateur':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showAddUserDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    String selectedRole = 'Collaborateur';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel Utilisateur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: const [
                  DropdownMenuItem(value: 'Administrateur', child: Text('Administrateur')),
                  DropdownMenuItem(value: 'Expert-comptable', child: Text('Expert-comptable')),
                  DropdownMenuItem(value: 'Collaborateur', child: Text('Collaborateur')),
                  DropdownMenuItem(value: 'Fiscaliste', child: Text('Fiscaliste')),
                ],
                onChanged: (value) {
                  selectedRole = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                await DatabaseHelper.instance.insert('users', {
                  'username': usernameController.text,
                  'email': emailController.text,
                  'password_hash': 'default_hash',
                  'role': selectedRole,
                  'full_name': nameController.text.isNotEmpty ? nameController.text : null,
                  'created_at': DateTime.now().toIso8601String(),
                  'is_active': 1,
                });
                _loadUsers();
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  const _SecurityTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSecurityCard(
          'Journalisation',
          'Activer la journalisation de toutes les actions',
          true,
        ),
        _buildSecurityCard(
          'Authentification',
          'Exiger un mot de passe complexe',
          true,
        ),
        _buildSecurityCard(
          'Session',
          'Déconnexion automatique après 30 min',
          false,
        ),
        _buildSecurityCard(
          'Export',
          'Autoriser l\'export des données',
          true,
        ),
        _buildSecurityCard(
          'Backup',
          'Sauvegarde automatique quotidienne',
          true,
        ),
      ],
    );
  }

  Widget _buildSecurityCard(String title, String subtitle, bool value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: (v) {},
          activeColor: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

class _AuditTab extends StatefulWidget {
  const _AuditTab();

  @override
  State<_AuditTab> createState() => _AuditTabState();
}

class _AuditTabState extends State<_AuditTab> {
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await DatabaseHelper.instance.query(
      'audit_logs',
      orderBy: 'created_at DESC',
    );
    setState(() {
      _logs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_logs.length} entrée(s) d\'audit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ElevatedButton.icon(
                onPressed: _exportLogs,
                icon: const Icon(Icons.download),
                label: const Text('Exporter'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _logs.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Aucun journal d\'audit'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Icon(
                          _getActionIcon(log['action']),
                          color: _getActionColor(log['action']),
                        ),
                        title: Text(log['action']),
                        subtitle: Text(
                          '${log['table_name'] ?? 'N/A'} - ${log['created_at']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  IconData _getActionIcon(String action) {
    if (action.contains('create')) return Icons.add;
    if (action.contains('update')) return Icons.edit;
    if (action.contains('delete')) return Icons.delete;
    if (action.contains('login')) return Icons.login;
    return Icons.history;
  }

  Color _getActionColor(String action) {
    if (action.contains('create')) return Colors.green;
    if (action.contains('update')) return Colors.blue;
    if (action.contains('delete')) return Colors.red;
    if (action.contains('login')) return Colors.orange;
    return Colors.grey;
  }

  void _exportLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export des journaux en cours...')),
    );
  }
}