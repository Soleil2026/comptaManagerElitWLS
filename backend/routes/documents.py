from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import get_db
from models.models import Document, Client, AuditLog, DocumentStatus

documents_bp = Blueprint('documents', __name__)


@documents_bp.route('/', methods=['GET'])
@jwt_required()
def get_documents():
    db = next(get_db())
    
    # Query params
    client_id = request.args.get('client_id', type=int)
    type_ = request.args.get('type')
    status = request.args.get('status')
    search = request.args.get('search')
    
    query = db.query(Document)
    
    if client_id:
        query = query.filter(Document.client_id == client_id)
    if type_:
        query = query.filter(Document.type == type_)
    if status:
        query = query.filter(Document.status == status)
    if search:
        query = query.filter(Document.title.ilike(f'%{search}%'))
    
    documents = query.order_by(Document.created_at.desc()).all()
    
    return jsonify({
        'documents': [{
            'id': d.id,
            'client_id': d.client_id,
            'client_name': d.client.name if d.client else None,
            'exercice_id': d.exercice_id,
            'type': d.type,
            'title': d.title,
            'description': d.description,
            'file_path': d.file_path,
            'status': d.status,
            'created_by': d.created_by,
            'created_at': d.created_at.isoformat() if d.created_at else None,
            'updated_at': d.updated_at.isoformat() if d.updated_at else None
        } for d in documents],
        'total': len(documents)
    })


@documents_bp.route('/<int:document_id>', methods=['GET'])
@jwt_required()
def get_document(document_id):
    db = next(get_db())
    document = db.query(Document).filter(Document.id == document_id).first()
    
    if not document:
        return jsonify({'error': 'Document not found'}), 404
    
    return jsonify({
        'id': document.id,
        'client_id': document.client_id,
        'client_name': document.client.name if document.client else None,
        'exercice_id': document.exercice_id,
        'type': document.type,
        'title': document.title,
        'description': document.description,
        'file_path': document.file_path,
        'status': document.status,
        'created_by': document.created_by,
        'created_at': document.created_at.isoformat() if document.created_at else None,
        'updated_at': document.updated_at.isoformat() if document.updated_at else None
    })


@documents_bp.route('/', methods=['POST'])
@jwt_required()
def create_document():
    identity = get_jwt_identity()
    data = request.get_json()
    
    if not data or not data.get('client_id') or not data.get('title') or not data.get('type'):
        return jsonify({'error': 'client_id, title, and type are required'}), 400
    
    db = next(get_db())
    
    # Verify client exists
    client = db.query(Client).filter(Client.id == data['client_id']).first()
    if not client:
        return jsonify({'error': 'Client not found'}), 404
    
    document = Document(
        client_id=data['client_id'],
        exercice_id=data.get('exercice_id'),
        type=data['type'],
        title=data['title'],
        description=data.get('description'),
        file_path=data.get('file_path'),
        status=data.get('status', DocumentStatus.TO_ANALYZE.value),
        created_by=identity['id']
    )
    
    db.add(document)
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='create',
        table_name='documents',
        record_id=document.id,
        details=f'Created document: {document.title}'
    )
    db.add(log)
    db.commit()
    db.refresh(document)
    
    return jsonify({
        'id': document.id,
        'client_id': document.client_id,
        'exercice_id': document.exercice_id,
        'type': document.type,
        'title': document.title,
        'description': document.description,
        'file_path': document.file_path,
        'status': document.status,
        'created_at': document.created_at.isoformat() if document.created_at else None
    }), 201


@documents_bp.route('/<int:document_id>', methods=['PUT'])
@jwt_required()
def update_document(document_id):
    identity = get_jwt_identity()
    data = request.get_json()
    
    db = next(get_db())
    document = db.query(Document).filter(Document.id == document_id).first()
    
    if not document:
        return jsonify({'error': 'Document not found'}), 404
    
    # Update fields
    if 'title' in data:
        document.title = data['title']
    if 'type' in data:
        document.type = data['type']
    if 'description' in data:
        document.description = data['description']
    if 'status' in data:
        document.status = data['status']
    if 'file_path' in data:
        document.file_path = data['file_path']
    if 'exercice_id' in data:
        document.exercice_id = data['exercice_id']
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='update',
        table_name='documents',
        record_id=document.id,
        details=f'Updated document: {document.title}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({
        'id': document.id,
        'client_id': document.client_id,
        'exercice_id': document.exercice_id,
        'type': document.type,
        'title': document.title,
        'description': document.description,
        'file_path': document.file_path,
        'status': document.status,
        'updated_at': document.updated_at.isoformat() if document.updated_at else None
    })


@documents_bp.route('/<int:document_id>', methods=['DELETE'])
@jwt_required()
def delete_document(document_id):
    identity = get_jwt_identity()
    
    db = next(get_db())
    document = db.query(Document).filter(Document.id == document_id).first()
    
    if not document:
        return jsonify({'error': 'Document not found'}), 404
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='delete',
        table_name='documents',
        record_id=document.id,
        details=f'Deleted document: {document.title}'
    )
    db.add(log)
    db.delete(document)
    db.commit()
    
    return jsonify({'message': 'Document deleted successfully'})