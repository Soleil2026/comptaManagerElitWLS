from flask import Blueprint, jsonify, request

clients_bp = Blueprint('clients', __name__)

@clients_bp.route('/', methods=['GET'])
def get_clients():
    return jsonify({
        'clients': [],
        'total': 0
    })

@clients_bp.route('/<int:id>', methods=['GET'])
def get_client(id):
    return jsonify({'id': id, 'name': 'Client'})

@clients_bp.route('/', methods=['POST'])
def create_client():
    data = request.json
    return jsonify({'status': 'created', 'id': 1}), 201

@clients_bp.route('/<int:id>', methods=['PUT'])
def update_client(id):
    data = request.json
    return jsonify({'status': 'updated', 'id': id})

@clients_bp.route('/<int:id>', methods=['DELETE'])
def delete_client(id):
    return jsonify({'status': 'deleted'}), 204