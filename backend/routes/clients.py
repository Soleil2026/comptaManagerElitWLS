from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import get_db
from models.models import Client, AuditLog

clients_bp = Blueprint('clients', __name__)


@clients_bp.route('/', methods=['GET'])
@jwt_required()
def get_clients():
    db = next(get_db())
    
    # Query params
    search = request.args.get('search', '')
    is_active = request.args.get('is_active', 'true').lower() == 'true'
    
    query = db.query(Client)
    
    if search:
        query = query.filter(
            (Client.name.ilike(f'%{search}%')) |
            (Client.code.ilike(f'%{search}%')) |
            (Client.ice.ilike(f'%{search}%'))
        )
    
    query = query.filter(Client.is_active == is_active)
    clients = query.order_by(Client.name).all()
    
    return jsonify({
        'clients': [{
            'id': c.id,
            'name': c.name,
            'code': c.code,
            'ice': c.ice,
            'rc': c.rc,
            'address': c.address,
            'city': c.city,
            'phone': c.phone,
            'email': c.email,
            'contact_person': c.contact_person,
            'contact_phone': c.contact_phone,
            'contact_email': c.contact_email,
            'is_active': c.is_active,
            'created_at': c.created_at.isoformat() if c.created_at else None
        } for c in clients],
        'total': len(clients)
    })


@clients_bp.route('/<int:client_id>', methods=['GET'])
@jwt_required()
def get_client(client_id):
    db = next(get_db())
    client = db.query(Client).filter(Client.id == client_id).first()
    
    if not client:
        return jsonify({'error': 'Client not found'}), 404
    
    return jsonify({
        'id': client.id,
        'name': client.name,
        'code': client.code,
        'ice': client.ice,
        'rc': client.rc,
        'address': client.address,
        'city': client.city,
        'phone': client.phone,
        'email': client.email,
        'contact_person': client.contact_person,
        'contact_phone': client.contact_phone,
        'contact_email': client.contact_email,
        'is_active': client.is_active,
        'created_at': client.created_at.isoformat() if client.created_at else None
    })


@clients_bp.route('/', methods=['POST'])
@jwt_required()
def create_client():
    identity = get_jwt_identity()
    data = request.get_json()
    
    if not data or not data.get('name'):
        return jsonify({'error': 'Name is required'}), 400
    
    db = next(get_db())
    
    # Check if code already exists
    if data.get('code'):
        existing = db.query(Client).filter(Client.code == data['code']).first()
        if existing:
            return jsonify({'error': 'Client code already exists'}), 400
    
    client = Client(
        name=data['name'],
        code=data.get('code'),
        ice=data.get('ice'),
        rc=data.get('rc'),
        address=data.get('address'),
        city=data.get('city'),
        phone=data.get('phone'),
        email=data.get('email'),
        contact_person=data.get('contact_person'),
        contact_phone=data.get('contact_phone'),
        contact_email=data.get('contact_email'),
        is_active=data.get('is_active', True)
    )
    
    db.add(client)
    db.commit()
    db.refresh(client)
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='create',
        table_name='clients',
        record_id=client.id,
        details=f'Created client: {client.name}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({
        'id': client.id,
        'name': client.name,
        'code': client.code,
        'ice': client.ice,
        'rc': client.rc,
        'address': client.address,
        'city': client.city,
        'phone': client.phone,
        'email': client.email,
        'contact_person': client.contact_person,
        'contact_phone': client.contact_phone,
        'contact_email': client.contact_email,
        'is_active': client.is_active,
        'created_at': client.created_at.isoformat() if client.created_at else None
    }), 201


@clients_bp.route('/<int:client_id>', methods=['PUT'])
@jwt_required()
def update_client(client_id):
    identity = get_jwt_identity()
    data = request.get_json()
    
    db = next(get_db())
    client = db.query(Client).filter(Client.id == client_id).first()
    
    if not client:
        return jsonify({'error': 'Client not found'}), 404
    
    # Update fields
    if 'name' in data:
        client.name = data['name']
    if 'code' in data:
        client.code = data['code']
    if 'ice' in data:
        client.ice = data['ice']
    if 'rc' in data:
        client.rc = data['rc']
    if 'address' in data:
        client.address = data['address']
    if 'city' in data:
        client.city = data['city']
    if 'phone' in data:
        client.phone = data['phone']
    if 'email' in data:
        client.email = data['email']
    if 'contact_person' in data:
        client.contact_person = data['contact_person']
    if 'contact_phone' in data:
        client.contact_phone = data['contact_phone']
    if 'contact_email' in data:
        client.contact_email = data['contact_email']
    if 'is_active' in data:
        client.is_active = data['is_active']
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='update',
        table_name='clients',
        record_id=client.id,
        details=f'Updated client: {client.name}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({
        'id': client.id,
        'name': client.name,
        'code': client.code,
        'ice': client.ice,
        'rc': client.rc,
        'address': client.address,
        'city': client.city,
        'phone': client.phone,
        'email': client.email,
        'contact_person': client.contact_person,
        'contact_phone': client.contact_phone,
        'contact_email': client.contact_email,
        'is_active': client.is_active,
        'created_at': client.created_at.isoformat() if client.created_at else None
    })


@clients_bp.route('/<int:client_id>', methods=['DELETE'])
@jwt_required()
def delete_client(client_id):
    identity = get_jwt_identity()
    
    db = next(get_db())
    client = db.query(Client).filter(Client.id == client_id).first()
    
    if not client:
        return jsonify({'error': 'Client not found'}), 404
    
    # Soft delete
    client.is_active = False
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='delete',
        table_name='clients',
        record_id=client.id,
        details=f'Deleted client: {client.name}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({'message': 'Client deleted successfully'})