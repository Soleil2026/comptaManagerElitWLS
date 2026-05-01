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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    try {
      final clients = await DatabaseHelper.instance.query(
        'clients',
        orderBy: 'name ASC',
      );
      setState(() {
        _clients = clients.map((c) => Client.fromMap(c)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteClient(Client client) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer suppression'),
        content: Text('Voulez-vous vraiment supprimer "${client.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.delete(
        'clients',
        where: 'id = ?',
        whereArgs: [client.id],
      );
      await _loadClients();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client supprimé'), backgroundColor: Colors.orange),
        );
      }
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
          ),
        ],
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClients.isEmpty
                    ? _buildEmptyState()
                    : _buildClientsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClientForm(),
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
            _clients.isEmpty ? 'Aucun client' : 'Aucun résultat',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _clients.isEmpty ? 'Cliquez sur + pour ajouter' : 'Essayez autre recherche',
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
            title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (client.code != null) Text('Code: ${client.code}', style: const TextStyle(fontSize: 12)),
                if (client.ice != null) Text('ICE: ${client.ice}', style: const TextStyle(fontSize: 12)),
                if (client.email != null) Text(client.email!, style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Modifier'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') _showClientForm(client: client);
                if (value == 'delete') _deleteClient(client);
              },
            ),
            isThreeLine: true,
            onTap: () => _showClientDetails(client),
          ),
        );
      },
    );
  }

  void _showClientDetails(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(client.name)),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pop(context);
                _showClientForm(client: client);
              },
            ),
          ],
        ),
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
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _showClientForm({Client? client}) {
    final isEdit = client != null;
    final nameController = TextEditingController(text: client?.name ?? '');
    final codeController = TextEditingController(text: client?.code ?? '');
    final iceController = TextEditingController(text: client?.ice ?? '');
    final rcController = TextEditingController(text: client?.rc ?? '');
    final addressController = TextEditingController(text: client?.address ?? '');
    final phoneController = TextEditingController(text: client?.phone ?? '');
    final emailController = TextEditingController(text: client?.email ?? '');
    final contactController = TextEditingController(text: client?.contactPerson ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEdit ? 'Modifier Client' : 'Nouveau Client'),
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Le champ Nom est obligatoire'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final Map<String, dynamic> data = {
                'name': nameController.text,
                'code': codeController.text.isEmpty ? null : codeController.text,
                'ice': iceController.text.isEmpty ? null : iceController.text,
                'rc': rcController.text.isEmpty ? null : rcController.text,
                'address': addressController.text.isEmpty ? null : addressController.text,
                'phone': phoneController.text.isEmpty ? null : phoneController.text,
                'email': emailController.text.isEmpty ? null : emailController.text,
                'contact_person': contactController.text.isEmpty ? null : contactController.text,
                'is_active': 1,
              };

              if (isEdit) {
                await DatabaseHelper.instance.update(
                  'clients',
                  data,
                  where: 'id = ?',
                  whereArgs: [client.id],
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client modifié!'), backgroundColor: Colors.green),
                  );
                }
              } else {
                data['created_at'] = DateTime.now().toIso8601String();
                final result = await DatabaseHelper.instance.insert('clients', data);
                if (result > 0 && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client ajouté!'), backgroundColor: Colors.green),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors de l\'ajout'), backgroundColor: Colors.red),
                  );
                }
              }

              _loadClients();
              await Future.delayed(const Duration(milliseconds: 300));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(isEdit ? 'Enregistrer' : 'Ajouter'),
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