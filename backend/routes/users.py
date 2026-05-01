from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import get_db
from models.models import User, AuditLog
from utils.auth import get_password_hash

users_bp = Blueprint('users', __name__)


@users_bp.route('/', methods=['GET'])
@jwt_required()
def get_users():
    db = next(get_db())
    
    # Only admins can list all users
    identity = get_jwt_identity()
    if identity['role'] != 'Administrateur':
        return jsonify({'error': 'Unauthorized'}), 403
    
    role = request.args.get('role')
    is_active = request.args.get('is_active')
    
    query = db.query(User)
    
    if role:
        query = query.filter(User.role == role)
    if is_active:
        query = query.filter(User.is_active == (is_active.lower() == 'true'))
    
    users = query.order_by(User.username).all()
    
    return jsonify({
        'users': [{
            'id': u.id,
            'username': u.username,
            'email': u.email,
            'role': u.role,
            'full_name': u.full_name,
            'phone': u.phone,
            'is_active': u.is_active,
            'created_at': u.created_at.isoformat() if u.created_at else None
        } for u in users],
        'total': len(users)
    })


@users_bp.route('/<int:user_id>', methods=['GET'])
@jwt_required()
def get_user(user_id):
    db = next(get_db())
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'full_name': user.full_name,
        'phone': user.phone,
        'is_active': user.is_active,
        'created_at': user.created_at.isoformat() if user.created_at else None
    })


@users_bp.route('/', methods=['POST'])
@jwt_required()
def create_user():
    identity = get_jwt_identity()
    
    # Only admins can create users
    if identity['role'] != 'Administrateur':
        return jsonify({'error': 'Unauthorized'}), 403
    
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password') or not data.get('email'):
        return jsonify({'error': 'Missing required fields'}), 400
    
    db = next(get_db())
    
    # Check if user exists
    if db.query(User).filter((User.username == data['username']) | (User.email == data['email'])).first():
        return jsonify({'error': 'User already exists'}), 400
    
    user = User(
        username=data['username'],
        email=data['email'],
        password_hash=get_password_hash(data['password']),
        role=data.get('role', 'Collaborateur'),
        full_name=data.get('full_name'),
        phone=data.get('phone')
    )
    
    db.add(user)
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='create',
        table_name='users',
        record_id=user.id,
        details=f'Created user: {user.username}'
    )
    db.add(log)
    db.commit()
    db.refresh(user)
    
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'full_name': user.full_name,
        'created_at': user.created_at.isoformat() if user.created_at else None
    }), 201


@users_bp.route('/<int:user_id>', methods=['PUT'])
@jwt_required()
def update_user(user_id):
    identity = get_jwt_identity()
    data = request.get_json()
    
    db = next(get_db())
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    # Only admin or self can update
    if identity['role'] != 'Administrateur' and identity['id'] != user_id:
        return jsonify({'error': 'Unauthorized'}), 403
    
    # Update fields
    if 'full_name' in data:
        user.full_name = data['full_name']
    if 'phone' in data:
        user.phone = data['phone']
    if 'role' in data and identity['role'] == 'Administrateur':
        user.role = data['role']
    if 'is_active' in data and identity['role'] == 'Administrateur':
        user.is_active = data['is_active']
    if 'password' in data:
        user.password_hash = get_password_hash(data['password'])
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='update',
        table_name='users',
        record_id=user.id,
        details=f'Updated user: {user.username}'
    )
    db.add(log)
    db.commit()
    
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'full_name': user.full_name,
        'is_active': user.is_active
    })


@users_bp.route('/<int:user_id>', methods=['DELETE'])
@jwt_required()
def delete_user(user_id):
    identity = get_jwt_identity()
    
    # Only admin can delete
    if identity['role'] != 'Administrateur':
        return jsonify({'error': 'Unauthorized'}), 403
    
    db = next(get_db())
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    # Can't delete yourself
    if identity['id'] == user_id:
        return jsonify({'error': 'Cannot delete yourself'}), 400
    
    # Audit log
    log = AuditLog(
        user_id=identity['id'],
        action='delete',
        table_name='users',
        record_id=user.id,
        details=f'Deleted user: {user.username}'
    )
    db.add(log)
    user.is_active = False
    db.commit()
    
    return jsonify({'message': 'User deleted successfully'})