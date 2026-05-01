from flask import Flask, jsonify
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from config import config
from models import init_db
from routes.auth import auth_bp
from routes.clients import clients_bp
from routes.documents import documents_bp
from routes.declarations import declarations_bp
from routes.users import users_bp
from routes.audit import audit_bp


def create_app(config_name='default'):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    CORS(app, origins=app.config['CORS_ORIGINS'], supports_credentials=True)
    JWTManager(app)
    
    # Initialize database
    init_db(app)
    
    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(clients_bp, url_prefix='/api/clients')
    app.register_blueprint(documents_bp, url_prefix='/api/documents')
    app.register_blueprint(declarations_bp, url_prefix='/api/declarations')
    app.register_blueprint(users_bp, url_prefix='/api/users')
    app.register_blueprint(audit_bp, url_prefix='/api/audit')
    
    # Health check
    @app.route('/api/health')
    def health():
        return jsonify({
            'status': 'ok',
            'version': '1.0.0',
            'service': 'comptaManagerDZ API'
        })
    
    @app.route('/')
    def index():
        return jsonify({
            'name': 'comptaManagerDZ API',
            'version': '1.0.0',
            'docs': '/api/health'
        })
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error'}), 500
    
    return app


if __name__ == '__main__':
    app = create_app('development')
    app.run(host='0.0.0.0', port=5000, debug=True)