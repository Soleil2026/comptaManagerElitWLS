"""
comptaManagerDZ - Backend Python
API REST pour la gestion des cabinets comptables
"""
from flask import Flask, jsonify
from flask_cors import CORS
from api.documents import documents_bp
from api.clients import clients_bp
from api.users import users_bp

app = Flask(__name__)
CORS(app)

app.register_blueprint(documents_bp, url_prefix='/api/documents')
app.register_blueprint(clients_bp, url_prefix='/api/clients')
app.register_blueprint(users_bp, url_prefix='/api/users')

@app.route('/api/health')
def health():
    return jsonify({'status': 'ok', 'version': '1.0.0'})

@app.route('/')
def index():
    return jsonify({
        'name': 'comptaManagerDZ API',
        'version': '1.0.0',
        'docs': '/api/docs'
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)