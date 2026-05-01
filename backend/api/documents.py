from flask import Blueprint, jsonify, request

documents_bp = Blueprint('documents', __name__)

@documents_bp.route('/', methods=['GET'])
def get_documents():
    return jsonify({
        'documents': [],
        'total': 0
    })

@documents_bp.route('/<int:id>', methods=['GET'])
def get_document(id):
    return jsonify({'id': id, 'title': 'Document'})

@documents_bp.route('/', methods=['POST'])
def create_document():
    data = request.json
    return jsonify({'status': 'created', 'id': 1}), 201

@documents_bp.route('/<int:id>', methods=['PUT'])
def update_document(id):
    data = request.json
    return jsonify({'status': 'updated', 'id': id})

@documents_bp.route('/<int:id>', methods=['DELETE'])
def delete_document(id):
    return jsonify({'status': 'deleted'}), 204

@documents_bp.route('/search', methods=['POST'])
def search_documents():
    return jsonify({'documents': [], 'total': 0})