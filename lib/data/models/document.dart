class Document {
  final int? id;
  final int clientId;
  final int? exerciceId;
  final String title;
  final String type;
  final String status;
  final String? filePath;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int createdBy;

  Document({
    this.id,
    required this.clientId,
    this.exerciceId,
    required this.title,
    required this.type,
    required this.status,
    this.filePath,
    this.description,
    DateTime? createdAt,
    this.updatedAt,
    required this.createdBy,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'exercice_id': exerciceId,
      'title': title,
      'type': type,
      'status': status,
      'file_path': filePath,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'created_by': createdBy,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      exerciceId: map['exercice_id'] as int?,
      title: map['title'] as String,
      type: map['type'] as String,
      status: map['status'] as String,
      filePath: map['file_path'] as String?,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      createdBy: map['created_by'] as int,
    );
  }
}