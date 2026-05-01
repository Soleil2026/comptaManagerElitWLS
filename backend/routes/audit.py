from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from models import get_db
from models.models import AuditLog

audit_bp = Blueprint('audit', __name__)


@audit_bp.route('/', methods=['GET'])
@jwt_required()
def get_audit_logs():
    db = next(get_db())
    
    # Query params
    user_id = request.args.get('user_id', type=int)
    action = request.args.get('action')
    table_name = request.args.get('table_name')
    limit = request.args.get('limit', 100, type=int)
    
    query = db.query(AuditLog)
    
    if user_id:
        query = query.filter(AuditLog.user_id == user_id)
    if action:
        query = query.filter(AuditLog.action == action)
    if table_name:
        query = query.filter(AuditLog.table_name == table_name)
    
    logs = query.order_by(AuditLog.created_at.desc()).limit(limit).all()
    
    return jsonify({
        'logs': [{
            'id': l.id,
            'user_id': l.user_id,
            'username': l.user.username if l.user else None,
            'action': l.action,
            'table_name': l.table_name,
            'record_id': l.record_id,
            'details': l.details,
            'ip_address': l.ip_address,
            'created_at': l.created_at.isoformat() if l.created_at else None
        } for l in logs],
        'total': len(logs)
    })


@audit_bp.route('/tables', methods=['GET'])
@jwt_required()
def get_tables():
    """Get list of tables with audit history"""
    return jsonify({
        'tables': [
            {'name': 'clients', 'description': 'Gestion des clients'},
            {'name': 'documents', 'description': 'Documents'},
            {'name': 'declarations', 'description': 'Déclarations fiscales'},
            {'name': 'users', 'description': 'Utilisateurs'},
            {'name': 'missions', 'description': 'Missions d\'audit'},
        ]
    })