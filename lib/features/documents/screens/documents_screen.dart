import 'package:flutter/material.dart';
import 'package:compta_manager/core/theme/app_theme.dart';
import 'package:compta_manager/core/constants/app_constants.dart';
import 'package:compta_manager/data/models/document.dart';
import 'package:compta_manager/data/models/client.dart';
import 'package:compta_manager/data/database/database_helper.dart';
import 'package:compta_manager/features/clients/screens/clients_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'Tous';
  String _selectedType = 'Tous';
  List<Document> _documents = [];
  List<Client> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final docs = await db.query('documents', orderBy: 'created_at DESC');
    final clients = await db.query('clients', orderBy: 'name');

    setState(() {
      _documents = docs.map((d) => Document.fromMap(d)).toList();
      _clients = clients.map((c) => Client.fromMap(c)).toList();
    });
  }

  List<Document> get _filteredDocuments {
    return _documents.where((doc) {
      final matchesSearch = _searchController.text.isEmpty ||
          doc.title.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedStatus == 'Tous' || doc.status == _selectedStatus;
      final matchesType = _selectedType == 'Tous' || doc.type == _selectedType;
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  String _getClientName(int clientId) {
    final client = _clients.where((c) => c.id == clientId).firstOrNull;
    return client?.name ?? 'Client#$clientId';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'À analyser':
        return Colors.orange;
      case 'En cours':
        return Colors.blue;
      case 'Validé':
        return Colors.green;
      case 'Signé':
        return Colors.purple;
      case 'Archivé':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub Documentaire'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _documents.isEmpty
                ? _buildEmptyState()
                : _buildDocumentsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDocumentDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.account_balance, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'comptaManagerDZ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  'Hub Documentaire',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Documents'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clients'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/clients');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Déclarations'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Administration'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['Tous', ...AppConstants.documentStatuses]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['Tous', ...AppConstants.documentTypes]
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun document',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Cliquez sur + pour ajouter un document',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final doc = _filteredDocuments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              _getDocumentIcon(doc.type),
              size: 40,
              color: AppTheme.primaryColor,
            ),
            title: Text(doc.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client: ${_getClientName(doc.clientId)}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(doc.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        doc.status,
                        style: TextStyle(
                          color: _getStatusColor(doc.status),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doc.type,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'Facture':
        return Icons.receipt;
      case 'Contrat':
        return Icons.description;
      case 'Déclaration':
        return Icons.assignment;
      case 'Rapport':
        return Icons.assessment;
      case 'Correspondance':
        return Icons.mail;
      case 'Pièce comptable':
        return Icons.calculate;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showAddDocumentDialog() {
    if (_clients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord ajouter un client')),
      );
      return;
    }

    final titleController = TextEditingController();
    String selectedType = AppConstants.documentTypes.first;
    String selectedClient = _clients.first.id.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Document'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: AppConstants.documentTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedClient,
                decoration: const InputDecoration(labelText: 'Client'),
                items: _clients
                    .map((c) => DropdownMenuItem(
                          value: c.id.toString(),
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedClient = value!;
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
              if (titleController.text.isNotEmpty) {
                await DatabaseHelper.instance.insert('documents', {
                  'client_id': int.parse(selectedClient),
                  'title': titleController.text,
                  'type': selectedType,
                  'status': 'À analyser',
                  'created_by': 1,
                });
                _loadData();
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}