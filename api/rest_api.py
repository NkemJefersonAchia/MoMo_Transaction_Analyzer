import base64
import json
from  http.server import HTTPServer, BaseHTTPRequestHandler

transactions = [] #list for linear search
transactions_dict = {} #for disctionary lookup

class APIHandler(BaseHTTPRequestHandler):
    def check_login(self):
        authentication_header = self.headers.get('Authorization')
        if not authentication_header:
            return False
        encoder = authentication_header.split('')[1]
        decoder = base64.b64decode(encoder).decode('utf-8')
        return decoder == "team5:ALU2025"
    def do_get(self):
        if not self.check_login():
            self.send_response(401)
            self.end_headers()
            return
        #show all transactions
        if self.path == '/transactions':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
