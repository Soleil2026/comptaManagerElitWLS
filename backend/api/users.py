from flask import Blueprint, jsonify, request

users_bp = Blueprint('users', __name__)

@users_bp.route('/', methods=['GET'])
def get_users():
    return jsonify({
        'users': [],
        'total': 0
    })

@users_bp.route('/<int:id>', methods=['GET'])
def get_user(id):
    return jsonify({'id': id, 'username': 'user'})

@users_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    return jsonify({
        'token': 'mock_token',
        'user': {'id': 1, 'username': 'admin', 'role': 'Administrateur'}
    })

@users_bp.route('/logout', methods=['POST'])
def logout():
    return jsonify({'status': 'logged_out'})

@users_bp.route('/', methods=['POST'])
def create_user():
    data = request.json
    return jsonify({'status': 'created', 'id': 1}), 201

@users_bp.route('/<int:id>', methods=['PUT'])
def update_user(id):
    data = request.json
    return jsonify({'status': 'updated', 'id': id})