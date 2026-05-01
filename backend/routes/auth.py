from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity
from models import get_db
from models.models import User
from utils.auth import verify_password, get_password_hash

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password') or not data.get('email'):
        return jsonify({'error': 'Missing required fields'}), 400
    
    db = next(get_db())
    
    # Check if user exists
    if db.query(User).filter((User.username == data['username']) | (User.email == data['email'])).first():
        return jsonify({'error': 'User already exists'}), 400
    
    # Create user
    user = User(
        username=data['username'],
        email=data['email'],
        password_hash=get_password_hash(data['password']),
        role=data.get('role', 'Collaborateur'),
        full_name=data.get('full_name')
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    access_token = create_access_token(identity={'id': user.id, 'username': user.username, 'role': user.role})
    refresh_token = create_refresh_token(identity={'id': user.id, 'username': user.username})
    
    return jsonify({
        'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'role': user.role,
            'full_name': user.full_name
        },
        'access_token': access_token,
        'refresh_token': refresh_token
    }), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': 'Missing username or password'}), 400
    
    db = next(get_db())
    user = db.query(User).filter(User.username == data['username']).first()
    
    if not user or not verify_password(data['password'], user.password_hash):
        return jsonify({'error': 'Invalid credentials'}), 401
    
    if not user.is_active:
        return jsonify({'error': 'Account is disabled'}), 403
    
    access_token = create_access_token(identity={'id': user.id, 'username': user.username, 'role': user.role})
    refresh_token = create_refresh_token(identity={'id': user.id, 'username': user.username})
    
    return jsonify({
        'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'role': user.role,
            'full_name': user.full_name
        },
        'access_token': access_token,
        'refresh_token': refresh_token
    })


@auth_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    identity = get_jwt_identity()
    access_token = create_access_token(identity=identity)
    return jsonify({'access_token': access_token})


@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def me():
    identity = get_jwt_identity()
    db = next(get_db())
    user = db.query(User).filter(User.id == identity['id']).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'full_name': user.full_name,
        'phone': user.phone,
        'is_active': user.is_active
    })


@auth_bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    return jsonify({'message': 'Successfully logged out'})