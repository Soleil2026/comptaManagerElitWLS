import 'package:flutter/material.dart';
import 'package:compta_manager/core/theme/app_theme.dart';
import 'package:compta_manager/data/models/client.dart';
import 'package:compta_manager/data/database/database_helper.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<Client> _clients = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await DatabaseHelper.instance.query(
      'clients',
      orderBy: 'name ASC',
    );
    setState(() {
      _clients = clients.map((c) => Client.fromMap(c)).toList();
    });
  }

  List<Client> get _filteredClients {
    return _clients.where((client) {
      final search = _searchController.text.toLowerCase();
      return search.isEmpty ||
          client.name.toLowerCase().contains(search) ||
          (client.code?.toLowerCase().contains(search) ?? false) ||
          (client.ice?.toLowerCase().contains(search) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, code, ICE...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _filteredClients.isEmpty
                ? _buildEmptyState()
                : _buildClientsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun client',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Cliquez sur + pour ajouter un client',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredClients.length,
      itemBuilder: (context, index) {
        final client = _filteredClients[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.secondaryColor,
              child: Text(
                client.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(client.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (client.code != null) Text('Code: ${client.code}'),
                if (client.ice != null) Text('ICE: ${client.ice}'),
                if (client.email != null) Text(client.email!),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            isThreeLine: true,
            onTap: () => _showClientDetails(client),
          ),
        );
      },
    );
  }

  void _showAddClientDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final iceController = TextEditingController();
    final rcController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Client'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: iceController,
                decoration: const InputDecoration(labelText: 'ICE'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rcController,
                decoration: const InputDecoration(labelText: 'RC'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Personne de contact'),
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
              if (nameController.text.isNotEmpty) {
                await DatabaseHelper.instance.insert('clients', {
                  'name': nameController.text,
                  'code': codeController.text.isNotEmpty ? codeController.text : null,
                  'ice': iceController.text.isNotEmpty ? iceController.text : null,
                  'rc': rcController.text.isNotEmpty ? rcController.text : null,
                  'address': addressController.text.isNotEmpty ? addressController.text : null,
                  'phone': phoneController.text.isNotEmpty ? phoneController.text : null,
                  'email': emailController.text.isNotEmpty ? emailController.text : null,
                  'contact_person': contactController.text.isNotEmpty ? contactController.text : null,
                  'created_at': DateTime.now().toIso8601String(),
                  'is_active': 1,
                });
                _loadClients();
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showClientDetails(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (client.code != null) _detailRow('Code', client.code!),
              if (client.ice != null) _detailRow('ICE', client.ice!),
              if (client.rc != null) _detailRow('RC', client.rc!),
              if (client.address != null) _detailRow('Adresse', client.address!),
              if (client.phone != null) _detailRow('Téléphone', client.phone!),
              if (client.email != null) _detailRow('Email', client.email!),
              if (client.contactPerson != null) _detailRow('Contact', client.contactPerson!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose;
  }
}