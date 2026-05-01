from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import get_db
from models.models import Declaration, Client, AuditLog

declarations_bp = Blueprint('declarations', __name__)


@declarations_bp.route('/', methods=['GET'])
@jwt_required()
def get_declarations():
    db = next(get_db())
    
    # Query params
    client_id = request.args.get('client_id', type=int)
    type_ = request.args.get('type')
    status = request.args.get('status')
    
    query = db.query(Declaration)
    
    if client_id:
        query = query.filter(Declaration.client_id == client_id)
    if type_:
        query = query.filter(Declaration.type == type_)
    if status:
        query = query.filter(Declaration.status == status)
    
    declarations = query.order_by(Declaration.deadline.desc()).all()
    
    return jsonify({
        'declarations': [{
            'id': d.id,
            'client_id': d.client_id,
            'client_name': d.client.name if d.client else None,
            'exercice_id': d.exercice_id,
            'type': d.type,
            'period': d.period,
            'amount': d.amount,
            'status': d.status,
            'submitted_at': d.submitted_at.isoformat() if d.submitted_at else None,
            'deadline': d.deadline.isoformat() if d.deadline else None,
            'notes': d.notes,
            'created_at': d.created_at.isoformat() if d.created_at else None
        } for d in declarations],
        'total': len(declarations)
    })


@declarations_bp.route('/<int:declaration_id>', methods=['GET'])
@jwt_required()
def get_declaration(declaration_id):
    db = next(get_db())
    declaration = db.query(Declaration).filter(Declaration.id == declaration_id).first()
    
    if not declaration:
        return jsonify({'error': 'Declaration not found'}), 404
    
    return jsonify({
        'id': declaration.id,
        'client_id': declaration.client_id,
        'client_name': declaration.client.name if declaration.client else None,
        'exercice_id': declaration.exercice_id,
        'type': declaration.type,
        'period': declaration.period,
        'amount': declaration.amount,
        'status': declaration.status,
        'submitted_at': declaration.submitted_at.isoformat() if declaration.submitted_at else None,
        'deadline': declaration.deadline.isoformat() if declaration.deadline else None,
        'notes': declaration.notes,
        'created_at': declaration.created_at.isoformat() if declaration.created_at else None
    })


@declarations_bp.route('/', methods=['POST'])
@jwt_required()
def create_declaration():
    identity = get_jwt_identity()
    data = request.get_json()
    
    if not data or not data.get('client_id') or not data.get('type'):
        return jsonify({'error': 'client_id and type are required'}), 400
    
    db = next(get_db())
    
    # Verify client exists
    client = db.query(Client).filter(Client.id == data['client_id']).first()
    if not client:
        return jsonify({'error': 'Client not found'}), 404
    
    declaration = Declaration(
        client_id=data['client_id'],
        exercice_id=data.get('exercice_id'),
        type=data['type'],
        period=data.get('period'),
        amount=data.get('amount', 0),
        status=data.get('status', 'Brouillon'),
        deadline=data.get('deadline'),
        notes=data.get('notes')
    )
    
    db.add(declaration)
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='create',
        table_name='declarations',
        record_id=declaration.id,
        details=f'Created {declaration.type} declaration for period {declaration.period}'
    )
    db.add(log)
    db.commit()
    db.refresh(declaration)
    
    return jsonify({
        'id': declaration.id,
        'client_id': declaration.client_id,
        'type': declaration.type,
        'period': declaration.period,
        'amount': declaration.amount,
        'status': declaration.status,
        'deadline': declaration.deadline.isoformat() if declaration.deadline else None,
        'created_at': declaration.created_at.isoformat() if declaration.created_at else None
    }), 201


@declarations_bp.route('/<int:declaration_id>', methods=['PUT'])
@jwt_required()
def update_declaration(declaration_id):
    identity = get_jwt_identity()
    data = request.get_json()
    
    db = next(get_db())
    declaration = db.query(Declaration).filter(Declaration.id == declaration_id).first()
    
    if not declaration:
        return jsonify({'error': 'Declaration not found'}), 404
    
    # Update fields
    if 'type' in data:
        declaration.type = data['type']
    if 'period' in data:
        declaration.period = data['period']
    if 'amount' in data:
        declaration.amount = data['amount']
    if 'status' in data:
        declaration.status = data['status']
    if 'deadline' in data:
        declaration.deadline = data['deadline']
    if 'notes' in data:
        declaration.notes = data['notes']
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='update',
        table_name='declarations',
        record_id=declaration.id,
        details=f'Updated declaration {declaration.id}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({
        'id': declaration.id,
        'client_id': declaration.client_id,
        'type': declaration.type,
        'period': declaration.period,
        'amount': declaration.amount,
        'status': declaration.status,
        'updated_at': declaration.updated_at.isoformat() if declaration.updated_at else None
    })


@declarations_bp.route('/<int:declaration_id>', methods=['DELETE'])
@jwt_required()
def delete_declaration(declaration_id):
    identity = get_jwt_identity()
    
    db = next(get_db())
    declaration = db.query(Declaration).filter(Declaration.id == declaration_id).first()
    
    if not declaration:
        return jsonify({'error': 'Declaration not found'}), 404
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='delete',
        table_name='declarations',
        record_id=declaration.id,
        details=f'Deleted declaration {declaration.id}'
    )
    db.add(log)
    db.delete(declaration)
    db.commit()
    
    return jsonify({'message': 'Declaration deleted successfully'})